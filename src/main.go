package main

import (
	"net/http"
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func goDotEnv(key string) string {
	// load .env file
	err := godotenv.Load(".env")
  
	if err != nil {
	  log.Fatalf("Error loading .env file")
	}
  
	return os.Getenv(key)
  }

func main() {
	gin.SetMode(gin.DebugMode)
	r := gin.Default()

	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"result" : "Hello World !!!",
		})
	})

	r.GET("/maintenance", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"MAINTENANCE" : goDotEnv("MAINTENANCE"),
		})
	})

	r.Run(":8000")
}