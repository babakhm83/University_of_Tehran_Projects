#ifndef _ERRORS_HPP
#define _ERRORS_HPP
class Error
{
};
class DUPLICATE_MISSION_ID : Error
{
};
class DUPLICATE_DRIVER_MISSION : Error
{
};
class INVALID_ARGUMENTS : Error
{
};
class MISSION_NOT_FOUND : Error
{
};
class DRIVER_MISSION_NOT_FOUND : Error
{
};
#endif