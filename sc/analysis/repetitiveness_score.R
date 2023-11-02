data <- read.csv("../../Data/ColdPlay.csv", nrow = 10)

compress_and_calculate_size <- function(raw_string) {
  raw_data <- charToRaw(raw_string)
  compressed_data <- memCompress(raw_data, "gzip")
  compressed_size <- length(compressed_data)
  original_size <- length(raw_data)
  return(list(compressed_size = compressed_size, original_size = original_size))
}

data$reduction_score <- sapply(data$Lyric, function(lyric) {
  size_info <- compress_and_calculate_size(lyric)
  reduction_percentage <- (1 - (size_info$compressed_size / size_info$original_size)) * 100
  return(reduction_percentage)
})

write.csv(data, "../../Data/ColdPlay_WithReduction.csv", row.names = FALSE)


