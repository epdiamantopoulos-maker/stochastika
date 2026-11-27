# Μικρογραφίες (thumbnails) των άρθρων για τη λίστα άρθρων και την κοινοποίηση
# σε κοινωνικά δίκτυα (og:image). Χωρίς κείμενο σε κάποια γλώσσα, ώστε η ίδια
# εικόνα να χρησιμεύει και στο el/ και στο en/.
#
# Εκτέλεση από τη ρίζα του αποθετηρίου:   Rscript _scripts/make_thumbnails.R
# Γράφει το thumbnail.png στο el/posts/<slug>/ και στο en/posts/<slug>/.
# Για νέο άρθρο: πρόσθεσε μια συνάρτηση στη λίστα `thumbs` και ξανατρέξε.

set.seed(2026)
col <- c(blue = "#4e79a7", orange = "#f28e2b", red = "#e15759", teal = "#76b7b2",
         green = "#59a14f", yellow = "#edc948", purple = "#b07aa1", grey = "#bab0ac")
ink <- "#33415c"
a <- function(x, al) grDevices::adjustcolor(x, alpha.f = al)

blank <- function(xlim = c(0, 1), ylim = c(0, 1)) {
  plot.new(); plot.window(xlim, ylim, asp = NA)
}
circ <- function(x, y, r, ...) {
  t <- seq(0, 2 * pi, length.out = 200); polygon(x + r * cos(t), y + r * sin(t), ...)
}
ellipse_asp <- function() { u <- par("usr"); p <- par("pin"); ((u[2]-u[1])/p[1]) / ((u[4]-u[3])/p[2]) }
circle <- function(x, y, r, ...) {  # κύκλος που φαίνεται κύκλος, ανεξάρτητα από την αναλογία
  k <- ellipse_asp(); t <- seq(0, 2 * pi, length.out = 200)
  polygon(x + r * k * cos(t), y + r * sin(t), ...)
}
omega <- function() {
  rect(0.03, 0.05, 0.97, 0.95, border = ink, lwd = 3)
  text(0.07, 0.87, expression(Omega), cex = 2.2, col = ink)
}
tree <- function(levels, labels = NULL, cols = col) {
  blank()
  nodes <- list(c(0.06, 0.5))
  for (l in seq_along(levels)) {
    k <- levels[l]; new <- list(); n <- length(nodes) * k
    ys <- seq(0.06, 0.94, length.out = n); x <- 0.06 + l * 0.88 / length(levels)
    j <- 0
    for (p in nodes) for (b in seq_len(k)) {
      j <- j + 1
      segments(p[1], p[2], x, ys[j], col = cols[(b - 1) %% length(cols) + 1], lwd = 4)
      new[[j]] <- c(x, ys[j])
    }
    for (q in nodes) points(q[1], q[2], pch = 19, cex = 2.2, col = ink)
    nodes <- new
  }
  for (q in nodes) points(q[1], q[2], pch = 19, cex = 1.8, col = ink)
  invisible(nodes)
}

thumbs <- list(
  "sample-spaces-events" = function() {
    blank(); omega()
    circle(0.42, 0.5, 0.3, col = a(col["blue"], .45), border = col["blue"], lwd = 3)
    circle(0.62, 0.5, 0.3, col = a(col["orange"], .45), border = col["orange"], lwd = 3)
    text(0.3, 0.5, "A", cex = 2.6, col = ink, font = 3); text(0.74, 0.5, "B", cex = 2.6, col = ink, font = 3)
  },
  "probability-definition" = function() {
    s <- 2:12; p <- (6 - abs(s - 7)) / 36
    barplot(p, col = col["blue"], border = NA, axes = FALSE, names.arg = s, cex.names = 1.6,
            col.axis = ink, space = 0.15)
  },
  "kolmogorov-axioms" = function() {
    blank(); omega()
    cs <- c(col["blue"], col["orange"], col["green"])
    xy <- list(c(0.3, 0.42), c(0.55, 0.6), c(0.78, 0.36))
    for (i in 1:3) {
      circle(xy[[i]][1], xy[[i]][2], 0.17, col = a(cs[i], .5), border = cs[i], lwd = 3)
      text(xy[[i]][1], xy[[i]][2], bquote(italic(A)[.(i)]), cex = 2.2, col = ink)
    }
  },
  "probability-approaches" = function() {
    n <- 400; blank(c(1, n), c(0, 1))
    abline(h = 0.5, lty = 2, lwd = 3, col = ink)
    for (k in 1:5) {
      x <- rbinom(n, 1, 0.5); lines(1:n, cumsum(x) / (1:n), col = col[k], lwd = 4)
    }
  },
  "counting-principle" = function() tree(c(2, 3, 2)),
  "permutations-arrangements" = function() {
    p <- rbind(c(1,2,3), c(1,3,2), c(2,1,3), c(2,3,1), c(3,1,2), c(3,2,1))
    cs <- col[c("blue", "orange", "green")]
    blank(c(0.5, 6.5), c(0.4, 3.6))
    for (i in 1:6) for (j in 1:3) {
      symbols(i, 4 - j, circles = 0.38, inches = FALSE, add = TRUE, bg = cs[p[i, j]], fg = "white", lwd = 3)
    }
  },
  "combinations" = function() {
    n <- 6; blank(c(-n - 1, n + 1), c(-0.6, n + 0.6))
    for (r in 0:n) for (k in 0:r) {
      x <- 2 * k - r; y <- n - r; v <- choose(r, k)
      symbols(x, y, circles = 0.85, inches = FALSE, add = TRUE,
              bg = a(col["blue"], 0.15 + 0.85 * v / choose(n, n/2)), fg = NA)
      text(x, y, v, cex = 1.5, col = if (v / choose(n, n/2) > 0.5) "white" else ink, font = 2)
    }
  },
  "bertrand-paradox" = function() {
    blank(c(-1.1, 1.1), c(-1.1, 1.1))
    k <- ellipse_asp(); t <- seq(0, 2*pi, length.out = 300)
    for (i in 1:45) {
      th <- runif(2, 0, 2*pi); long <- abs(sin((th[1]-th[2])/2)) > sqrt(3)/2
      segments(k*cos(th[1]), sin(th[1]), k*cos(th[2]), sin(th[2]),
               col = if (long) col["blue"] else a(col["orange"], .8), lwd = 2.5)
    }
    lines(k*cos(t), sin(t), lwd = 4, col = ink)
    a3 <- pi/2 + c(0, 2*pi/3, 4*pi/3, 0)
    lines(k*cos(a3), sin(a3), lwd = 3, lty = 2, col = col["red"])
  },
  "foundations-exercises" = function() {
    blank(c(0.4, 6.6), c(0.4, 6.6))
    for (i in 1:6) for (j in 1:6) {
      f <- if (i + j == 7) col["orange"] else if (i == j) col["blue"] else a(col["grey"], .45)
      rect(i - 0.45, j - 0.45, i + 0.45, j + 0.45, col = f, border = NA)
    }
  },
  "conditional-probability" = function() {
    g <- expand.grid(x = 1:14, y = 1:9); inB <- g$x <= 8; inA <- g$y <= 4
    blank(c(0.3, 14.7), c(0.3, 9.7))
    rect(0.45, 0.45, 8.55, 9.55, col = a(col["blue"], .12), border = col["blue"], lwd = 3)
    points(g$x, g$y, pch = 19, cex = 2.3,
           col = ifelse(inA & inB, col["red"], ifelse(inA, a(col["red"], .35), ifelse(inB, col["blue"], col["grey"]))))
  },
  "multiplication-rule" = function() {
    blank()
    br <- function(x0, y0, x1, y1, p, hi) segments(x0, y0, x1, y1, lwd = 2 + 18 * p,
                                                   col = if (hi) col["red"] else a(col["blue"], .45), lend = 1)
    br(0.06, 0.5, 0.48, 0.78, 0.4, TRUE);  br(0.06, 0.5, 0.48, 0.22, 0.6, FALSE)
    br(0.48, 0.78, 0.94, 0.92, 1/3, TRUE); br(0.48, 0.78, 0.94, 0.64, 2/3, FALSE)
    br(0.48, 0.22, 0.94, 0.36, 4/9, FALSE); br(0.48, 0.22, 0.94, 0.08, 5/9, FALSE)
    points(c(0.06, 0.48, 0.48, rep(0.94, 4)), c(0.5, 0.78, 0.22, 0.92, 0.64, 0.36, 0.08),
           pch = 21, cex = 3.2, bg = c(ink, col["red"], col["blue"], col["red"], col["blue"], col["red"], col["blue"]), col = "white", lwd = 2)
  },
  "independence" = function() {
    blank()
    pA <- 0.6; pB <- 0.45
    rect(0.05, 0.05, 0.95, 0.95, border = ink, lwd = 3)
    rect(0.05, 0.05, 0.05 + 0.9 * pA, 0.95, col = a(col["blue"], .35), border = NA)
    rect(0.05, 0.05, 0.95, 0.05 + 0.9 * pB, col = a(col["orange"], .35), border = NA)
    rect(0.05, 0.05, 0.05 + 0.9 * pA, 0.05 + 0.9 * pB, col = a(col["red"], .55), border = ink, lwd = 3)
    text(0.05 + 0.45 * pA, 0.05 + 0.45 * pB, expression(italic(P(A)) %.% italic(P(B))), cex = 1.9, col = "white", font = 2)
  },
  "total-probability" = function() {
    blank(); omega()
    xs <- c(0.03, 0.27, 0.48, 0.72, 0.97); cs <- col[c("blue", "orange", "green", "purple")]
    for (i in 1:4) rect(xs[i], 0.05, xs[i+1], 0.95, col = a(cs[i], .25), border = ink, lwd = 2)
    k <- ellipse_asp(); t <- seq(0, 2*pi, length.out = 200)
    polygon(0.5 + 0.36 * cos(t), 0.48 + 0.24 * sin(t), col = a(col["red"], .5), border = col["red"], lwd = 4)
    for (i in 1:4) text((xs[i] + xs[i+1]) / 2, 0.13, bquote(italic(B)[.(i)]), cex = 2, col = ink)
    text(0.5, 0.48, "A", cex = 2.4, font = 3, col = "white")
  },
  "bayes-theorem" = function() {
    x <- seq(0, 1, length.out = 400); blank(c(0, 1), c(0, 9.5))
    pars <- list(c(1,1), c(3,2), c(8,4), c(22,10), c(60,25))
    for (i in seq_along(pars)) {
      y <- dbeta(x, pars[[i]][1], pars[[i]][2])
      polygon(c(0, x, 1), c(0, y, 0), col = a(col["blue"], 0.08 + 0.12 * i), border = col["blue"], lwd = 2 + i/2)
    }
    abline(h = 0, col = ink, lwd = 3)
  },
  "monty-hall" = function() {
    blank(c(0, 3), c(0, 1.25))
    for (i in 1:3) {
      x0 <- i - 0.85; x1 <- i - 0.15
      if (i == 3) {
        rect(x0, 0.1, x1, 1, col = a(col["grey"], .3), border = ink, lwd = 3)
        polygon(c(x0, x0 + 0.16, x0 + 0.16, x0), c(0.1, 0.02, 1.08, 1), col = col["orange"], border = ink, lwd = 3)
      } else {
        rect(x0, 0.1, x1, 1, col = if (i == 1) col["blue"] else col["green"], border = ink, lwd = 3)
        points(x1 - 0.1, 0.55, pch = 19, cex = 2, col = "white")
        text((x0 + x1)/2, 0.75, if (i == 1) "1/3" else "2/3", col = "white", cex = 2.6, font = 2)
      }
    }
  },
  "sensitivity-specificity" = function() {
    x <- seq(-4, 7, length.out = 500); t0 <- 1.8
    blank(range(x), c(0, 0.45))
    y0 <- dnorm(x, 0, 1); y1 <- dnorm(x, 3, 1.2)
    polygon(c(x[x >= t0], rev(x[x >= t0])), c(y1[x >= t0], rep(0, sum(x >= t0))), col = a(col["green"], .5), border = NA)
    polygon(c(x[x >= t0], rev(x[x >= t0])), c(y0[x >= t0], rep(0, sum(x >= t0))), col = a(col["red"], .6), border = NA)
    lines(x, y0, lwd = 4, col = col["blue"]); lines(x, y1, lwd = 4, col = col["orange"])
    abline(v = t0, lwd = 3, lty = 2, col = ink); abline(h = 0, lwd = 3, col = ink)
  },
  "base-rate-fallacy" = function() {
    g <- expand.grid(x = 1:25, y = 1:12)
    st <- rep(col["grey"], nrow(g)); idx <- sample(nrow(g))
    st[idx[1:4]] <- col["red"]; st[idx[5:22]] <- col["orange"]
    blank(c(0.5, 25.5), c(0.5, 12.5))
    points(g$x, g$y, pch = 19, cex = 2, col = st)
  },
  "roc-auc" = function() {
    blank(c(0, 1), c(0, 1))
    rect(0, 0, 1, 1, border = ink, lwd = 3)
    f <- function(x, g) 1 - (1 - x)^g
    x <- seq(0, 1, length.out = 200)
    polygon(c(x, 1, 0), c(f(x, 6), 0, 0), col = a(col["blue"], .25), border = NA)
    lines(x, f(x, 6), lwd = 5, col = col["blue"]); lines(x, f(x, 2.2), lwd = 5, col = col["orange"])
    abline(0, 1, lty = 2, lwd = 3, col = ink)
  },
  "system-reliability" = function() {
    blank(c(0, 10), c(0, 6))
    box <- function(x, y, c) rect(x - 0.7, y - 0.5, x + 0.7, y + 0.5, col = c, border = ink, lwd = 3)
    segments(0.2, 3, 1.6, 3, lwd = 4, col = ink); box(2.3, 3, col["blue"]); segments(3, 3, 4, 3, lwd = 4, col = ink)
    segments(4, 1.3, 4, 4.7, lwd = 4, col = ink); segments(7, 1.3, 7, 4.7, lwd = 4, col = ink)
    for (y in c(1.3, 3, 4.7)) { segments(4, y, 4.8, y, lwd = 4, col = ink); segments(6.2, y, 7, y, lwd = 4, col = ink); box(5.5, y, col["orange"]) }
    segments(7, 3, 8, 3, lwd = 4, col = ink); box(8.7, 3, col["green"]); segments(9.4, 3, 9.9, 3, lwd = 4, col = ink)
  },
  "conditional-exercises" = function() {
    blank()
    m <- matrix(c(0.35, 0.15, 0.1, 0.4), 2)
    cs <- matrix(c(col["blue"], a(col["blue"], .45), col["orange"], a(col["orange"], .45)), 2)
    w <- colSums(m); x0 <- 0.05
    for (j in 1:2) {
      h <- m[, j] / w[j]; y0 <- 0.05
      for (i in 1:2) {
        rect(x0, y0, x0 + 0.88 * w[j], y0 + 0.9 * h[i], col = cs[i, j], border = "white", lwd = 6)
        y0 <- y0 + 0.9 * h[i]
      }
      x0 <- x0 + 0.88 * w[j] + 0.02
    }
  }
  ,
  "random-variables" = function() {
    blank(c(0, 9), c(0, 6))
    k <- c(3, 2, 2, 1, 2, 1, 1, 0); xv <- 1.6 + 1.9 * k
    for (i in 1:8) segments(i, 4.6, xv[i], 1.35, col = a(col["blue"], .55), lwd = 3)
    for (i in 1:8) rect(i - 0.4, 4.6, i + 0.4, 5.6, col = if (k[i] == 2) col["orange"] else "white", border = ink, lwd = 3)
    segments(0.5, 1, 8.5, 1, lwd = 4, col = ink)
    symbols(1.6 + 1.9 * 0:3, rep(1, 4), circles = rep(0.32, 4), inches = FALSE, add = TRUE,
            bg = c("white", "white", col["orange"], "white"), fg = ink, lwd = 3)
  },
  "probability-mass-function" = function() {
    x <- 0:12; f <- 0.25 * 0.75^x
    blank(c(-0.6, 12.6), c(0, 0.27))
    rect(x - 0.36, 0, x + 0.36, f, col = ifelse(x <= 3, col["orange"], col["blue"]), border = NA)
    segments(-0.6, 0, 12.6, 0, lwd = 3, col = ink)
  },
  "cumulative-distribution-function" = function() {
    x <- 0:3; F <- cumsum(c(1, 3, 3, 1) / 8)
    blank(c(-1, 4), c(-0.05, 1.05))
    segments(-1, 0, 0, 0, lwd = 6, col = col["blue"])
    segments(x, F, c(x[-1], 4), F, lwd = 6, col = col["blue"])
    points(x, c(0, F[-4]), pch = 21, bg = "white", col = col["blue"], cex = 3, lwd = 3)
    points(x, F, pch = 19, col = col["blue"], cex = 3)
    segments(-1, -0.03, 4, -0.03, lwd = 3, col = ink)
    segments(1.5, -0.03, 1.5, F[2], lty = 2, lwd = 3, col = col["orange"])
    points(1.5, F[2], pch = 19, col = col["orange"], cex = 3.2)
  }
)

# συχνότητες 600 ρίψεων ζαριού, με τις έδρες από κάτω
thumbs[["random-experiments"]] <- function() {
  x <- sample(1:6, 600, TRUE); f <- as.numeric(table(factor(x, 1:6))) / 600
  blank(c(0.4, 6.6), c(-0.07, 0.24))
  rect(1:6 - 0.38, 0, 1:6 + 0.38, f, col = col[1:6], border = NA)
  abline(h = 1/6, lty = 2, lwd = 3, col = ink)
  pip <- list(0, c(-1, 1), c(-1, 0, 1), c(-1, -1, 1, 1), c(-1, -1, 0, 1, 1), c(-1, -1, -1, 1, 1, 1))
  piy <- list(0, c(1, -1), c(1, 0, -1), c(1, -1, 1, -1), c(1, -1, 0, 1, -1), c(1, 0, -1, 1, 0, -1))
  for (i in 1:6) {
    rect(i - 0.3, -0.065, i + 0.3, -0.01, border = ink, lwd = 2.5, col = "white")
    points(i + pip[[i]] * 0.16, -0.0375 + piy[[i]] * 0.016, pch = 19, cex = 1.1, col = ink)
  }
}

# σ.π.π. 3x² με χρωματισμένο εμβαδόν κάτω από την καμπύλη
thumbs[["probability-density-function"]] <- function() {
  blank(c(-0.08, 1.12), c(-0.15, 3.1))
  x <- seq(0, 1, length.out = 200)
  xa <- seq(0.5, 0.85, length.out = 100)
  polygon(c(0.5, xa, 0.85), c(0, 3 * xa^2, 0), col = a(col["orange"], 0.75), border = NA)
  lines(x, 3 * x^2, lwd = 7, col = col["blue"])
  segments(-0.08, 0, 0, 0, lwd = 7, col = col["blue"]); segments(1, 0, 1.12, 0, lwd = 7, col = col["blue"])
  segments(-0.08, -0.06, 1.12, -0.06, lwd = 3, col = ink)
}

# τραμπάλα: στήλες σ.μ.π. πάνω σε δοκό που ισορροπεί στο κέντρο βάρους
thumbs[["expected-value"]] <- function() {
  blank(c(-0.6, 6.6), c(-0.16, 0.42))
  p <- c(0.06, 0.2, 0.32, 0.22, 0.12, 0.06, 0.02); x <- 0:6; m <- sum(x * p)
  rect(x - 0.3, 0.02, x + 0.3, 0.02 + p, col = col["blue"], border = NA)
  rect(-0.5, 0, 6.5, 0.02, col = ink, border = NA)
  polygon(c(m, m - 0.35, m + 0.35), c(0, -0.13, -0.13), col = col["orange"], border = NA)
}

# μέσοι όροι ρίψεων ζαριού που συγκλίνουν στο 3,5
thumbs[["law-of-large-numbers"]] <- function() {
  N <- 3000
  blank(c(0, log10(N)), c(2.2, 4.8))
  abline(h = 3.5, lwd = 6, col = col["green"])
  for (k in 1:4) {
    r <- cumsum(sample(1:6, N, TRUE)) / seq_len(N)
    lines(log10(seq_len(N)), pmin(pmax(r, 2.25), 4.75), lwd = 4, col = col[c("blue", "orange", "purple", "teal")][k])
  }
}

slugs <- basename(list.dirs("el/posts", recursive = FALSE))
missing <- setdiff(slugs, names(thumbs))
if (length(missing)) message("Χωρίς μικρογραφία: ", paste(missing, collapse = ", "))
for (s in intersect(names(thumbs), slugs)) {
  f <- file.path("el/posts", s, "thumbnail.png")
  png(f, width = 900, height = 600, res = 110, bg = "white")
  par(mar = c(0.6, 0.6, 0.6, 0.6))
  thumbs[[s]]()
  dev.off()
  file.copy(f, file.path("en/posts", s, "thumbnail.png"), overwrite = TRUE)
}
cat("OK:", length(intersect(names(thumbs), slugs)), "μικρογραφίες\n")
