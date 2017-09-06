#include <gtest/gtest.h>
#include <snappy.h>

TEST(snappy, compress) {
  std::string compressed, uncompressed;
  std::string hello = "hello";
  auto size = snappy::Compress(hello.c_str(), hello.size(), &compressed);
  EXPECT_TRUE(size != 0);
  EXPECT_EQ(compressed.size(), size);
  
  EXPECT_TRUE(snappy::Uncompress(compressed.c_str(), compressed.size(), &uncompressed));
  EXPECT_EQ(hello, uncompressed);
}
