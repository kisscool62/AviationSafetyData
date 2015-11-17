


df <- read.csv('aviation_safety_data.csv', , encoding="UTF-8-BOM")
df$X.location

gsub(df$X.location, pattern='(.+)\\([:blank:]+([^(]+[(]?[^(]+[)]?)\\)', replacement = "\\2")

gsub("\\((.*?) :: (0\\.[0-9]+)\\)","\\1 \\2", "(sometext :: 0.1231313213)") "sometext 0.1231313213"