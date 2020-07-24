## Put comments here that give an overall description of what your
## functions do

## Write a short comment describing this function 


## Start with a function taking a matrix aa its argument 
makeCacheMatrix <- function(x = matrix()) {
    i <- NULL                                     ## initialize the inverse of matrix to NULL 
    setmatrix <- function(y = matrix(x)) {        ## a new function to set the initial value of the matrix as a global variable (by using <<-)
        x <<- y                                    
        i <<- NULL                                ## and to change the value of inverse to NULL in case it has been changed
    }
    getmatrix <- function() x                     ## returns the initial value of the matrix
    setinverse <- function(inverse) i <<- inverse ## to set the inverse of the initial matrix (this is to be cached)
    getinverse <- function() i                    ## returns the calculated inverse when called
    list(setmatrix = setmatrix, getmatrix = getmatrix, setinverse = setinverse, getinverse = getinverse)
                                                  ## return the four functions together as a list
}


## Write a short comment describing this function

cacheSolve <- function(x, ...) {
    i <- x$getinverse()                           ## pass the value of inverse from the makeCacheMatrix function to the function scope variable i
    if(!is.null(i)) {                             ## the initial value of inverse has been set to NULL, if the value is found to be NULL , we will bring cached data
      print("getting cached data")
      return(i)                                   ## return the cached value of matrix
    }
    data <- x$getmatrix()                         ## gets the initial matrix in a variable named data
    i <- solve(data,...)                          ## use solve function to calculate the inverse
    x$setinverse(i)                               ## change the value of inverse to new
    i                                             ## return newly calculated inverse
    ## Return a matrix that is the inverse of 'x'
}
