# Blog Database Design
A database design for a blog platform with users, posts and comments. Includes a relational schema, MongoDB document model, sample CRUD/read/aggregation queries, indexes and an ER diagram.

## Entities and relationships
- **users**: account identity and password hash.
- **posts**: each post belongs to one author (`posts.author_id`).
- **comments**: each comment belongs to one post and one user.
- Relationships: users 1-to-many posts; posts 1-to-many comments; users 1-to-many comments.

## Run SQL
1. Create a PostgreSQL database, e.g. `blog_db`.
2. Run `psql -d blog_db -f sql/schema.sql`.
3. Execute examples from `sql/queries.sql` after inserting matching sample records.

## MongoDB
Run `mongodb/blog-schema.js` in `mongosh`. The sample ObjectIds are placeholders; replace them with actual IDs from your test database.

## Design decisions
Unique constraints protect usernames, emails and slugs. Status fields use check/enum validation. Deleting a post cascades to comments; deleting an author is restricted. Passwords must be hashed before storage.
