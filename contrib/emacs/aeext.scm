
;;; aeext.scm  30.12.91  Thomas Gordon

; Extensions to Author/Editor to support qwertz formatting commands

(define qwertz-menu (add-menu "Qwertz" 7))
(define-script (xpuzzle) (system "puzzle &"))

(define xpuzzle-button (add-menu-item "Xpuzzle" 1 qwertz-menu xpuzzle)))
