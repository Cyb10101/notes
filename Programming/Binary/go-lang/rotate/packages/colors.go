package colors

func textColor(textColor string, message string) string {
  return "\033[0;3" + textColor + "m" + message + "\033[0m"
}

func Black(message string) string {
  return textColor("0", message)
}
func Red(message string) string {
  return textColor("1", message)
}
func Green(message string) string {
  return textColor("2", message)
}
func Yellow(message string) string {
  return textColor("3", message)
}
func Blue(message string) string {
  return textColor("4", message)
}
func Purple(message string) string {
  return textColor("5", message)
}
func Cyan(message string) string {
  return textColor("6", message)
}
func Grey(message string) string {
  return textColor("7", message)
}
