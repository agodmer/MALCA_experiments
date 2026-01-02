# MALCA demo: synthetic data + RF-RFE + Random Forest
# Reproducible toy pipeline (synthetic only)

# ============================================================
# 1) Setup
# ============================================================
set.seed(123)

suppressPackageStartupMessages({
  library(caret)
  library(randomForest)
  library(pROC)
})

# ============================================================
# 2) Generate a synthetic dataset (multi-class) with a small signal
# ============================================================
n <- 5000
p <- 25
classes <- c("nonCPE", "OXA48", "NDM", "KPC", "VIM", "IMP")

# Class imbalance (somewhat realistic)
probs <- c(0.55, 0.25, 0.12, 0.03, 0.04, 0.01)
y <- factor(sample(classes, size = n, replace = TRUE, prob = probs),
            levels = classes)

# Noise features centered around "diameter-like" values
X <- matrix(rnorm(n * p, mean = 20, sd = 5), nrow = n, ncol = p)
colnames(X) <- paste0("AB", sprintf("%02d", 1:p))

# Inject weak class-dependent signals into a few "key antibiotics"
shift <- function(vec, cls, delta) vec + ifelse(y == cls, delta, 0)

# AB03 could mimic a strong discriminator (e.g., CZA-like)
X[, "AB03"] <- shift(X[, "AB03"], "KPC",  -6)
X[, "AB03"] <- shift(X[, "AB03"], "OXA48", -2)
X[, "AB03"] <- shift(X[, "AB03"], "NDM",  -7)

# AB07 could mimic temocillin-like signal for OXA48
X[, "AB07"] <- shift(X[, "AB07"], "OXA48", -6)

# AB11 could mimic carbapenem-like signal for nonCPE (more susceptible)
X[, "AB11"] <- shift(X[, "AB11"], "nonCPE", +4)

# AB15 could mimic mecillinam-like signal for VIM
X[, "AB15"] <- shift(X[, "AB15"], "VIM", -5)

# Bound to plausible inhibition zone diameters (e.g., 6 to 35 mm)
X <- pmin(pmax(X, 6), 35)

dat <- data.frame(y = y, X)

# ============================================================
# 3) Train/test split (stratified)
# ============================================================
set.seed(123)
idx <- createDataPartition(dat$y, p = 0.7, list = FALSE)
train <- dat[idx, ]
test  <- dat[-idx, ]

# ============================================================
# 4) Upstream feature selection: RF-based RFE (RF-RFE)
# ============================================================
set.seed(123)

ctrl_rfe <- rfeControl(
  functions = rfFuncs,   # RF for variable ranking
  method = "cv",
  number = 5,
  verbose = FALSE,
  returnResamp = "final"
)

# Candidate subset sizes to evaluate
sizes <- c(2, 4, 6, 8, 10, 12, 15, 20, 25)

rfe_fit <- rfe(
  x = train[, -1],
  y = train$y,
  sizes = sizes,
  rfeControl = ctrl_rfe,
  metric = "Kappa"
)

print(rfe_fit)
cat("\nSelected variables:\n")
print(predictors(rfe_fit))

# ============================================================
# 5) Train a simple Random Forest using only the selected features
# ============================================================
sel_vars <- predictors(rfe_fit)

ctrl_train <- trainControl(
  method = "cv",
  number = 5,
  classProbs = TRUE,
  summaryFunction = multiClassSummary,
  savePredictions = "final"
)

set.seed(123)
rf_fit <- train(
  x = train[, sel_vars, drop = FALSE],
  y = train$y,
  method = "rf",
  metric = "Kappa",
  trControl = ctrl_train,
  tuneLength = 5
)

print(rf_fit)

# ============================================================
# 6) Evaluate on the held-out test set
# ============================================================
pred <- predict(rf_fit, newdata = test[, sel_vars, drop = FALSE])
cm <- confusionMatrix(pred, test$y)
print(cm)

# ============================================================
# 7) (Optional) "Confidence score" = max predicted class probability
#    and evaluate only high-confidence predictions
# ============================================================
probs_pred <- predict(rf_fit, newdata = test[, sel_vars, drop = FALSE], type = "prob")
conf_score <- apply(probs_pred, 1, max)

# Example threshold: keep top 90% most confident predictions
threshold <- quantile(conf_score, 0.10)
keep <- conf_score >= threshold

cat("\nTypability (fraction kept):", mean(keep), "\n")
cm_keep <- confusionMatrix(pred[keep], test$y[keep])
print(cm_keep)

# ============================================================
# 8) (Optional) One-vs-rest AUC for a class (e.g., OXA48 vs others)
# ============================================================
y_bin <- factor(ifelse(test$y == "OXA48", "OXA48", "Other"))
roc_obj <- roc(response = y_bin, predictor = probs_pred$OXA48, levels = c("Other", "OXA48"))
cat("\nAUC (OXA48 vs rest) =", as.numeric(auc(roc_obj)), "\n")

# ============================================================
# 9) Record session info for reproducibility
# ============================================================
cat("\n\n--- sessionInfo() ---\n")
print(sessionInfo())