/*****************************************************************************
 *  Copyright (c) 2004 WebEx Communications, Inc.
 *  All rights reserved	
 *
 *  read_config.h
 *
 *  Author
 *      Steven Huang(stevenh@hz.webex.com) 
 *
 *  Abstract
 *      Class for reading parameter settings in a configure file.
 *
 *  History
 *      08/18/2008 Created
 *
 *****************************************************************************/
#ifndef READ_FILE_H__
#define READ_FILE_H__

#include <stdlib.h>
#include <string>
#include <vector>
using namespace std;

class CReadFile
{
public:
	CReadFile( const char *config_file_name );
	virtual ~CReadFile();
	
	long ReadLine( string* val, const int val_size = 4 );
	string ReadtsLine();

	long ParseFile(vector<string> &m_TagsVec);

	const bool EndOfFile();
	const int  GetLines();
	const bool ExistFile();
	const string& GetFileName();
	
private:
	FILE			*m_cfg_file;
	string			m_cfg_file_name;
	unsigned long	m_nlines;

	//vector<string> m_TagsVec;
};

#endif	// READ_CONFIG_H__

