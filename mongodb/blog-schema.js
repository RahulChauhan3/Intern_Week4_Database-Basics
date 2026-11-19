// MongoDB model: users, posts and comments are separate collections.
// Separate comments prevent unbounded embedded arrays on popular posts.
db.createCollection("users",{validator:{$jsonSchema:{bsonType:"object",required:["username","email","passwordHash","createdAt"],properties:{username:{bsonType:"string",minLength:3,maxLength:40},email:{bsonType:"string"},passwordHash:{bsonType:"string"},displayName:{bsonType:"string"},createdAt:{bsonType:"date"}}}}});
db.createCollection("posts",{validator:{$jsonSchema:{bsonType:"object",required:["authorId","title","slug","body","status","createdAt"],properties:{authorId:{bsonType:"objectId"},title:{bsonType:"string",maxLength:180},slug:{bsonType:"string"},body:{bsonType:"string"},status:{enum:["draft","published","archived"]},publishedAt:{bsonType:["date","null"]},createdAt:{bsonType:"date"},updatedAt:{bsonType:"date"}}}}});
db.createCollection("comments",{validator:{$jsonSchema:{bsonType:"object",required:["postId","userId","body","status","createdAt"],properties:{postId:{bsonType:"objectId"},userId:{bsonType:"objectId"},body:{bsonType:"string"},status:{enum:["visible","hidden"]},createdAt:{bsonType:"date"}}}}});
db.users.createIndex({username:1},{unique:true}); db.users.createIndex({email:1},{unique:true});
db.posts.createIndex({slug:1},{unique:true}); db.posts.createIndex({status:1,publishedAt:-1}); db.posts.createIndex({authorId:1});
db.comments.createIndex({postId:1,createdAt:1}); db.comments.createIndex({userId:1});

// Create post (replace placeholder ObjectId with an actual users._id)
db.posts.insertOne({authorId:ObjectId("665000000000000000000001"),title:"A Practical Guide to APIs",slug:"practical-guide-to-apis",body:"An introduction to useful APIs.",status:"published",publishedAt:new Date(),createdAt:new Date(),updatedAt:new Date()});
// Read latest published posts
db.posts.find({status:"published"}).sort({publishedAt:-1}).limit(10);
// Read comments for a post
db.comments.find({postId:ObjectId("665000000000000000000002"),status:"visible"}).sort({createdAt:1});
// Count comments by post
db.comments.aggregate([{$match:{status:"visible"}},{$group:{_id:"$postId",commentCount:{$sum:1}}},{$sort:{commentCount:-1}}]);
// Update and delete
db.posts.updateOne({_id:ObjectId("665000000000000000000002")},{$set:{title:"Updated API Guide",updatedAt:new Date()}});
db.comments.deleteOne({_id:ObjectId("665000000000000000000003"),userId:ObjectId("665000000000000000000001")});
