(defpackage ticket-modelling-challenge
  (:use :cl :dynamic-mixins))
(in-package :ticket-modelling-challenge)

;;; Personnel

(deftype status ()
  '(member
    adult
    student
    high-school-student
    junior-high-school-student
    kid))

(deftype gender ()
  '(member
    male
    female
    other))

(defclass person ()
  ((status :initarg :status :reader status :type 'status)
   (age :initarg :age :reader age :type 'fixnum)
   (challengedp :initarg :challengedp :reader challengedp :type 'boolean)
   (gender :initarg :gender :reader gender :type 'gender)
   (partner :initarg :partner :reader partner :type 'person)))

(defclass adult-person (person) ())

(defclass student (person) ())

(defclass high-school-student (person) ())

(defclass junior-high-school-student (person) ())

(defclass kid (person) ())

(defclass senior-person (person) ())

(defclass challenged-person (person) ())

(defclass women (person) ())

(defclass 50-50-pair (person) ())

(defun make-person (status age challengedp gender partner)
  (let* ((p (make-instance 'person
                           :status status
                           :gender gender
                           :challengedp challengedp
                           :age age
                           :partner partner)))
    ;; TODO: 50-50
    (when (eq gender 'women)
      (ensure-mix p 'women))
    (when challengedp
      (ensure-mix p 'challenged-person))
    (when (>= age 60)
      (ensure-mix p 'senior-person))
    (when (eq status 'kid)
      (ensure-mix p 'kid))
    (when (eq status 'junior-high-school-student)
      (ensure-mix p 'junior-high-school-student))
    (when (eq status 'high-school-student)
      (ensure-mix p 'high-school-student))
    (when (eq status 'student)
      (ensure-mix p 'student))
    (when (eq status 'adult)
      (ensure-mix p 'adult-person))
    p))

;;; day

(defclass day () ())
(defclass weekday () ())
(defclass holiday () ())
(defclass ladies-day () ())
(defclass cinema-service-day () ())
(defclass cinema-day () ())

(defun make-day (year month day)
  (let ((timestamp (local-time:encode-timestamp 0 0 0 0 day month year)))
    (ensure-mix timestamp 'day)
    (if (member (local-time:timestamp-day-of-week timestamp) '(0 6))
        (ensure-mix timestamp 'holiday)
        (ensure-mix timestamp 'weekday))
    (when (eq (local-time:timestamp-day-of-week timestamp) 3)
      (ensure-mix timestamp 'ladies-day))
    (when (eq (local-time:timestamp-day timestamp) 1)
      (ensure-mix timestamp 'cinema-service-day))
    (when (and (eq (local-time:timestamp-month timestamp) 12)
               (eq (local-time:timestamp-day timestamp) 1))
      (ensure-mix timestamp 'cinema-day))
    timestamp))

;;; cinema

(defclass cinema ()
  ((title :initarg :title :reader title :type 'string)
   (loaded-show-at :initarg :loaded-show-at :reader loaded-show-at :type 'local-time:timestamp)
   (3d-cinema-p :initarg :3d-cinema-p :reader 3d-cinema-p :type 'boolean)))
(defclass late-cinema (cinema) ())
(defclass 3d-cinema (cinema) ())

(defmethod late-show-p ((cinema cinema))
 )

(defun make-cinema (title loaded-show-at 3d-cinema-p)
  (let ((cinema (make-instance 'cinema
                               :title title
                               :3d-cinema-p 3d-cinema-p
                               :loaded-show-at loaded-show-at)))
    (when (>= (local-time:timestamp-hour loaded-show-at) 20)
      (ensure-mix cinema 'late-cinema))
    (when 3d-cinema-p
      (ensure-mix cinema '3d-cinema))
    cinema))

;;; Rules

;;; Normal rules
(defmethod price ((p person) (d day) (c cinema) membership-p)
  (error "Not in rules"))

(defmethod price ((p adult-person) (d day) (c cinema) membership-p)
  1800)

(defmethod price ((p student) (d day) (c cinema) membership-p)
  1500)

(defmethod price ((p high-school-student) (d day) (c cinema) membership-p)
  1000)
(defmethod price ((p junior-high-school-student) (d day) (c cinema) membership-p)
  1000)
(defmethod price ((p kid) (d day) (c cinema) membership-p)
  1000)

(defmethod price ((p senior-person) (d day) (c cinema) membership-p)
  1100)

(defmethod price ((p challenged-person) (d day) (c cinema) membership-p)
  1000)

;;; Membership rules
(defmethod price ((p adult-person) (d weekday) (c cinema) (membership-p (eql t)))
  1100)

(defmethod price ((p adult-person) (d holiday) (c cinema) (membership-p (eql t)))
  1500)

(defmethod price ((p student) (d weekday) (c cinema) (membership-p (eql t)))
  1000)

(defmethod price ((p high-school-student) (d day) (c cinema) (membership-p (eql t)))
  1000)

(defmethod price ((p junior-high-school-student) (d day) (c cinema) (membership-p (eql t)))
  800)

(defmethod price ((p kid) (d day) (c cinema) (membership-p (eql t)))
  800)

;; TODO: 同伴者

;; Discount rule

(defmethod price ((p women) (d ladies-day) (c cinema) membership-p)
  1100)

(defmethod price ((p person) (d cinema-service-day) (c cinema) membership-p)
  1100)
(defmethod price ((p person) (d cinema-day) (c cinema) membership-p)
  1000)

(defmethod price ((p person) (d day) (c late-cinema) membership-p)
  1300)

(defmethod price ((p 50-50-pair) (d day) (c cinema) membership-p)
  2200)

(defmethod price :around ((p person) (d day) (c 3d-cinema) membership-p)
  (+ 300 (call-next-method)))
