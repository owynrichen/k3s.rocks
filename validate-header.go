package main

import (
	"bufio"
	"fmt"
	"os"
)

func validHeaderFieldValue(v string) bool {
	for i := 0; i < len(v); i++ {
		b := v[i]
		if isCTL(b) && !isLWS(b) {
			return false
		}
	}
	return true
}

func isCTL(b byte) bool {
	const del = 0x7f // a CTL
	return b < ' ' || b == del
}

func isLWS(b byte) bool { return b == ' ' || b == '\t' }

func main() {
	scanner := bufio.NewScanner(os.Stdin)

	for scanner.Scan() {
		text := scanner.Text()
		valid := validHeaderFieldValue(text)

		if valid {
			fmt.Printf("Valid! '%s'\n", text)
		} else {
			fmt.Printf("Invalid... '%s'\n", text)
		}
	}

	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "error:", err)
	}
}
