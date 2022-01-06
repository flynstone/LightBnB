/*
In our applications, we will separate out our SQL into two different parts.

    The part that we write as the developer, the part that we have complete control over.
    The part that comes from somewhere else and might be malicious.

The part that we write:
*/

const queryString = `
  SELECT students.id as student_id, students.name as name, cohorts.name as cohort
  FROM students
  JOIN cohorts ON cohorts.id = cohort_id
  WHERE cohorts.name LIKE $1
  LIMIT $2;
  `;


/*
Each $s in our query is a placeholder that represents where a value should go but can't because it's coming from somewhere else, so it might be malicious. For most of our applications, 
this data will come from an under user using an HTML form. For this example, it's coming from process.argv.

The values that come from somewhere else:
*/

const cohortName = process.argv[2];
const limit = process.argv[3] || 5;
// Store all potentially malicious values in an array.
const values = [`%${cohortName}%`, limit];

/*
The $1 and $2 placeholders will eventually get replaced with the actual data from the values array. The numbering starts at 1 instead of 0, 
so the first value in the query $1 corresponds to the first value in the array values[0].

When we're ready to run the query, we can send both of these parts to the database:

pool.query(queryString, values);

PostgreSQL receives these two pieces of information separately. It knows that the first part is a safe query that it can run and that the second part is data that may be malicious. 
It will use the values as data within the query but it will not run the values as part of the query. This protects us from SQL injection.

Always use parameterized queries when you have data that comes from an untrusted source, which is pretty much every source.
*/