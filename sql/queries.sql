-- Use a securely hashed password; never store plaintext.
INSERT INTO users(username,email,password_hash,display_name)
VALUES('maya_dev','maya@example.com','$2b$12$replace_with_real_hash','Maya');
INSERT INTO posts(author_id,title,slug,body,status,published_at)
VALUES(1,'A Practical Guide to APIs','practical-guide-to-apis','An introduction to useful APIs.','published',CURRENT_TIMESTAMP);

-- Read published posts with author details
SELECT p.id,p.title,p.slug,p.published_at,u.display_name AS author
FROM posts p JOIN users u ON u.id=p.author_id
WHERE p.status='published' ORDER BY p.published_at DESC;

-- Read visible comments for a post
SELECT c.id,c.body,c.created_at,u.display_name AS commenter
FROM comments c JOIN users u ON u.id=c.user_id
WHERE c.post_id=1 AND c.status='visible' ORDER BY c.created_at ASC;

-- Update a post
UPDATE posts SET title='A Practical Guide to REST APIs',updated_at=CURRENT_TIMESTAMP
WHERE id=1 AND author_id=1;

-- Delete a comment
DELETE FROM comments WHERE id=10 AND user_id=1;

-- Count visible comments per published post
SELECT p.id,p.title,COUNT(c.id) AS comment_count
FROM posts p LEFT JOIN comments c ON c.post_id=p.id AND c.status='visible'
WHERE p.status='published' GROUP BY p.id,p.title ORDER BY comment_count DESC;
