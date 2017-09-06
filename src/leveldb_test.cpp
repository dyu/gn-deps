#include <gtest/gtest.h>
#include <leveldb/db.h>

TEST(leveldb, open) {
  leveldb::DB* db;
  leveldb::Options options;
  options.create_if_missing = true;
  leveldb::Status s = leveldb::DB::Open(options, "target/testdb", &db);
  EXPECT_TRUE(s.ok());
  
  std::string key = "foo";
  std::string val = "bar";
  std::string gval;
  s = db->Put(leveldb::WriteOptions(), key, val);
  if (s.ok()) {
    s = db->Get(leveldb::ReadOptions(), key, &gval);
    EXPECT_TRUE(s.ok());
    EXPECT_EQ(val, gval);
  }
  
  delete db;
}
