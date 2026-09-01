;;; ox-leanpub-common.el --- Shared helpers for ox-leanpub  -*- lexical-binding: t; -*-

;; Copyright (C) 2019-2026 Diego Zamboni

;; Author: Diego Zamboni <diego@zzamboni.org>
;; URL: https://gitlab.com/zzamboni/ox-leanpub
;; Package-Version: 0.4
;; Keywords: files, org, leanpub
;; Package-Requires: ((org "9.1") (emacs "26.1"))

;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at

;;     https://www.apache.org/licenses/LICENSE-2.0

;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

;;; Commentary:

;; Shared helper functions used by the ox-leanpub exporters.

;;; Code:

(require 'cl-lib)
(require 'ob-core)

(defconst org-leanpub--valid-markua-versions '("0.10" "0.30")
  "Valid values for the `#+MARKUA_VERSION' export option.")

(defun org-leanpub--markua-version (info)
  "Return normalized Markua version from INFO.

The `#+MARKUA_VERSION' option accepts only \"0.10\" and \"0.30\".
Any other value triggers a warning and falls back to \"0.10\"."
  (let ((version (format "%s" (or (plist-get info :markua-version) "0.10"))))
    (if (member version org-leanpub--valid-markua-versions)
        version
      (lwarn '(ox-leanpub) :warning
             "Invalid MARKUA_VERSION '%s'. Using default version 0.10."
             version)
      "0.10")))

(defun org-leanpub--markua-doc-settings (info)
  "Return parsed `#+MARKUA_DOC_SETTINGS' entries from INFO.

Multiple lines are supported. Later values override earlier ones
for the same key."
  (let ((settings-str (plist-get info :markua-doc-settings)))
    (when settings-str
      (cl-remove-duplicates
       (apply #'append
              (mapcar #'org-babel-parse-header-arguments
                      (split-string settings-str "\n" t "[ \t]*")))
       :key #'car
       :from-end t))))

(defun org-leanpub--markua-doc-setting (info key)
  "Return Markua document setting KEY from INFO, or nil."
  (alist-get key (org-leanpub--markua-doc-settings info)))

(provide 'ox-leanpub-common)

;;; ox-leanpub-common.el ends here
