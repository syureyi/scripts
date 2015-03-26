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
#if !defined(WIN32)
#include <string.h>
#include <stdio.h>
#endif



#include "read_file.h"

#include <fstream>

CReadFile::CReadFile( const char *config_file_name )
: m_cfg_file(0)
, m_cfg_file_name(config_file_name)
, m_nlines(0)
{
	if ( strlen(config_file_name) > 0 ){	// FIXME: To check validation in configure file name
		m_cfg_file = fopen(config_file_name, "rb");
	}
}

CReadFile::~CReadFile()
{
	if ( m_cfg_file ){
		fclose( m_cfg_file );
		m_cfg_file = NULL;
	}
}
string CReadFile::ReadtsLine( )
{
	if ( m_cfg_file == NULL)
		return NULL;
	
	string strTags ;

	do {
		const char ch = (char)fgetc(m_cfg_file);
		
		if ( ch == '\t' ||ch==' '|| feof(m_cfg_file) )
		{
			++ m_nlines;
			return strTags;
		}
		else
		{

			strTags += ch;
		}
				
	} while(true);
	
	return strTags;
}

 long CReadFile::ParseFile(vector<string> &m_TagsVec)
{
	std::fstream fs;
	fs.open(m_cfg_file_name.c_str(), fstream::in);
	if (!fs.is_open()) {
		return -1;
	}

	m_TagsVec.clear();

	while(!fs.eof()) {
		string line;
		getline(fs, line);

		int pos = line.find_first_of(" ");
		if (pos == -1) {
			pos = line.find_first_of("\t");
		}

		if (pos == -1) {
			continue;
		}

		string tag = line.substr(0, pos);
		m_TagsVec.push_back(tag);
	}

	fs.close();

	return 0;

}

long CReadFile::ReadLine( string* val, const int val_size/* = 4*/ )
{
	if ( m_cfg_file == NULL || val == NULL || val_size <= 1)
		return 0;
	
	string *strTags = &val[0];
	int nTagNum = 0, n = 0;
	bool comment_flag = false;	
	
	while (n < val_size) {
		val[n]	= "";
		++ n;
	}	

	do {
		const char ch = (char)fgetc(m_cfg_file);
		
		if ( ch == '\n' || feof(m_cfg_file) ){
			++ m_nlines;
			break;
		}
		if ( ch == '#' )
			comment_flag = true;
		if ( !comment_flag ){
			if ( ch == '\t' || ch == ' ' ){
				if ( nTagNum >= val_size )
					break;
				if ( !(*strTags).empty() ){
					++ nTagNum;
					strTags	= &val[nTagNum];
				}
			}
			else
				*strTags += ch;
		}
		
	} while(true);
	
	return 1+nTagNum;
}

const bool CReadFile::EndOfFile()
{
	if (m_cfg_file == NULL)
		return true;
	return feof(m_cfg_file) ? true : false;
}

const int CReadFile::GetLines()
{
		return m_nlines;
}

const bool CReadFile::ExistFile()
{
	return (m_cfg_file != NULL);
}

const string& CReadFile::GetFileName()
{
	return m_cfg_file_name;
}
