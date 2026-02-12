
lambda { |stdout,stderr,status|
  output = stdout + stderr
  return :green if /^\s*Test Count: \d+, Passed: \d+, Failed: 0, Warnings: \d+, Inconclusive: \d+, Skipped: \d+/.match(output)
  return :red   if /^Failed!/.match(output)
  return :amber
}
