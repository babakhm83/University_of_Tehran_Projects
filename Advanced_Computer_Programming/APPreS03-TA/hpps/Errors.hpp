#ifndef _ERRORS_HPP
#define _ERRORS_HPP
#include <string>
using namespace std;
class Error
{
public:
    string error() { return error_message; };

protected:
    string error_message;
};
class INVALID_QUESTION_TYPE : public Error
{
public:
    INVALID_QUESTION_TYPE() : Error() { error_message = "INVALID QUESTION TYPE"; };
};
class INVALID_COMMAND : public Error
{
public:
    INVALID_COMMAND() : Error() { error_message = "INVALID COMMAND"; };
};
class INVALID_ANSWER : public Error
{
public:
    INVALID_ANSWER() : Error() { error_message = "INVALID ANSWER"; };
};
class ALREADY_ASSIGNED : public Error
{
public:
    ALREADY_ASSIGNED() : Error() { error_message = "YOU\'VE ALREADY ASSIGNED AN ANSWER TO THIS QUESTION"; };
};
class EMPTY_FILE : public Error
{
public:
    EMPTY_FILE() : Error() { error_message = "EMPTY FILE"; };
};
class FILE_NOT_FOUND : public Error
{
public:
    FILE_NOT_FOUND() : Error() { error_message = "FILE NOT FOUND"; };
};
#endif