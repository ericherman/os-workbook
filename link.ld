ENTRY(start)			/* the name of the entry label */

SECTIONS {
	. = 0x00100000;		/* the code should be loaded at 1 MB */
	_our_start = .;		/* save this address to variable _our_start */

	.text ALIGN (0x1000) :	/* align at 4 KB */
	{
		*(.text)	/* all text sections from all files */
	}

	RODATA_START = .;
	.rodata ALIGN (0x1000) :
	{
		*(.rodata*)	/* all read-only data sections from all files */
	}

	DATA_START = .;
	.data ALIGN (0x1000) :
	{
		*(.data)	/* all data sections from all files */
	}

	BSS_START = .;
	.bss ALIGN (0x1000) :
	{
		*(COMMON)	/* all COMMON sections from all files */
		*(.bss)		/* all bss sections from all files */
	}

	NOTE_START = .;
	.note ALIGN (0x1000) :
	{
		*(.note)
	}

	_our_end = .;
}
