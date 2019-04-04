/* 
Synonyms are references to another already existing objects in a database, like a link to that objects so they add another layer of abstraction. They are used for:

- Security: Users that issue queries can't see the real names of the tables.

- Maintenance: You can drop synonym and create it again to point to another table. Can use one underlying table for testing, and other for production. Also useful when you have database link setup.

Synonyms can be private or public. It is possible to have private and public synonym with the same name, in that case Oracle has a order of precedence (first private, then public).
*/

CREATE OR REPLACE PUBLIC SYNONYM
my_public_synonym FOR mitja_se_uci.ms_postavke;