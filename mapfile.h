#ifndef _FILE_MEM_MAP_
#define _FILE_MEM_MAP_

#include <stdio.h>
#ifdef LINUX
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#endif

#ifndef NULL
#define NULL 0
#endif

class CMapFile 
{
public:
	CMapFile()
	{
#ifdef LINUX
		m_fd = -1;
#endif
		m_addr = NULL;
		m_length = 0;
		m_offset = 0;
	}
	
	virtual ~CMapFile()
	{
		uninit();
	}
	
	bool init(const char *fname, unsigned long length=-1, unsigned offset=0)
	{
		uninit();
						
#ifdef LINUX
		m_fd = open(fname, O_RDONLY);
		if (m_fd == -1) {
			return false;
		}
		
		struct stat fstat;
		if ( stat(fname, (struct stat *)&fstat) < 0 ) {
			return false;
		}
		
		if (length == -1) {
			m_length = fstat.st_size;
		}else {
			m_length = length;
		}
		m_offset = offset;
	
		m_addr = mmap(NULL, m_length, PROT_READ, MAP_PRIVATE, m_fd, m_offset);
		if (m_addr == MAP_FAILED) {
			return false;
		}
#endif
		return true;
	}
	
	void *ptr()
	{
		return m_addr;
	}

	unsigned long size()
	{
		return m_length;
	}
	
void uninit()
	{		
#ifdef LINUX
		if (m_addr) 
		{
			munmap(m_addr, m_length);
			m_addr = NULL;
		}
		
		if (m_fd >= 0) 
		{
			close(m_fd);
			m_fd = -1;
		}
#endif
		m_length = 0;
		m_offset = 0;
	}
	
private:	
	void * m_addr;
	unsigned long m_length;
	unsigned long m_offset;
	
#ifdef LINUX
	int m_fd;
#endif
	
};


#endif
