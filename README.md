ExceptionMapper-Ruby
====================

This library, developed &amp; maintained by AFour Technologies, helps you effectively analyze your automation errors and segregates them on the fly. Invariably, after executing a UI automation run you would observe many test cases which have failed. Rarely do you see a clean “all-green” execution. These failures can be either real bugs in the AUT or they might be errors due to various other environmental reasons, like, Timeouts, Synchronization issues, DB Connection issues, etc. which create a lot of noise in the final test report and actually do not help anyone in the chain. It is frustrating for a QA, who has to check each of these failures manually to make sure that he hasn’t missed a real bug. A lot of time is wasted in analyzing these errors. You can use this library to segregate theses errors into “Environmental” or “Functional” defects which you can add to your test report. You can then just simply ignore the Environmental errors and concentrate on analyzing the Functional ones.
