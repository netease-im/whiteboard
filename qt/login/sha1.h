/*
 *	sha1.h
 *
 *	Copyright (C) 1998
 *	Paul E. Jones <paulej@arid.us>
 *	All Rights Reserved.
 *
 *****************************************************************************
 *	$Id: sha1.h,v 1.6 2004/03/27 18:02:26 paulej Exp $
 *****************************************************************************
 *
 *	Description:
 * 		This class implements the Secure Hashing Standard as defined
 * 		in FIPS PUB 180-1 published April 17, 1995.
 *
 *		Many of the variable names in this class, especially the single
 *		character names, were used because those were the names used
 *		in the publication.
 *
 * 		Please read the file sha1.cpp for more information.
 *
 * 		This is the same as MD5.
 * /*
 *  Created on: 2009-3-26
 *      Author: root
 *      usage	:	char SHABuffer[41];
 *					SHA1 SHA;
 *					SHA.SHA_GO("gfc",SHABuffer);
 *					ִ�����֮��SHABuffer�м��洢����"a string"����õ���SHAֵ
 		�㷨������
					1.����γ���512 bits(64�ֽ�), (N+1)*512;
								N*512 + 448λ                         64λ
						��ʵ���� + ���(һ��1��������0)		 		������ʵ���ݵĳ���
						�������������������������������������������� ----------------------
					2.�ĸ�32λ����Ϊ���ӱ���������������
						A=��B=��C=��D=,E=
					3.��ʼ�㷨������ѭ�����㡣
						ѭ���Ĵ���(N+1)����Ϣ��512λ��Ϣ�������Ŀ��
						for(N+1, ÿ��ȡ512 bits(64�ֽ�)�����д���)
						{
							512bits �ֳ�16������(ÿ������4�ֽڡ�int data[16])
							��16�������е�ÿһ�������A��B��C��D,Eͨ��4�������������㣬
							�õ��µ�A��B��C��D,E
						}
					4.��󣬽�A��B��C��D,Eƴ����������SHAֵ
						��ƴ�Ӻ��ֵ���ַ����ķ�ʽ��ʾ�������������յĽ����
						(���� 0x234233F, �ô� ��234233F����ʾ���������ɵĴ��Ŀռ佫��ֵ�Ŀռ��2����)
 *		�������: �ô����Ѿ�����ͨ����
 */

#ifndef _SHA1_H_
#define _SHA1_H_

#include<string.h>
#include<stdio.h>

class SHA1
{
	public:
		SHA1();
		virtual ~SHA1();
		bool SHA_GO(const char *lpData_Input, char *lpSHACode_Output );
	private:
		unsigned int H[5];					// Message digest buffers
		unsigned int Length_Low;				// Message length in bits
		unsigned int Length_High;			// Message length in bits
		unsigned char Message_Block[64];	// 512-bit message blocks
		int Message_Block_Index;				// Index into message block array
	private:
		void SHAInit();
		void AddDataLen(int nDealDataLen);

		// Process the next 512 bits of the message
		void ProcessMessageBlock();

		// Pads the current message block to 512 bits
		void PadMessage();

		// Performs a circular left shift operation
		inline unsigned CircularShift(int bits, unsigned word);
};

#endif
