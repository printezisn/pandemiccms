CREATE DATABASE
IF NOT EXISTS pandemiccms_development;
GRANT ALL PRIVILEGES ON `pandemiccms_development`.* TO `pandemiccms`@`%`;
FLUSH PRIVILEGES;

CREATE DATABASE
IF NOT EXISTS pandemiccms_test;
GRANT ALL PRIVILEGES ON `pandemiccms_test`.* TO `pandemiccms`@`%`;
FLUSH PRIVILEGES;