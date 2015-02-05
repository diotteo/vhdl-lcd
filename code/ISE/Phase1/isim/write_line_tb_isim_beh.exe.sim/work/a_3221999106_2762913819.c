/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x8ef4fb42 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "//sole.ens.ad.etsmtl.ca/ENS2/HOME/AK67270/ELE740/phase1/Phase 1/testbenches/write_line/write_line_tb.vhd";



static void work_a_3221999106_2762913819_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    unsigned char t4;
    unsigned char t5;
    char *t6;
    char *t7;
    char *t8;
    int64 t9;

LAB0:    t1 = (t0 + 1896U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(29, ng0);
    t2 = (t0 + 1236U);
    t3 = *((char **)t2);
    t4 = *((unsigned char *)t3);
    t5 = (!(t4));
    if (t5 != 0)
        goto LAB4;

LAB6:    xsi_set_current_line(32, ng0);
    t2 = (t0 + 2280);
    t3 = (t2 + 32U);
    t6 = *((char **)t3);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(33, ng0);
    t9 = (5 * 1000LL);
    t2 = (t0 + 1796);
    xsi_process_wait(t2, t9);

LAB13:    *((char **)t1) = &&LAB14;

LAB1:    return;
LAB4:    xsi_set_current_line(30, ng0);

LAB9:    *((char **)t1) = &&LAB10;
    goto LAB1;

LAB5:    goto LAB2;

LAB7:    goto LAB5;

LAB8:    goto LAB7;

LAB10:    goto LAB8;

LAB11:    xsi_set_current_line(34, ng0);
    t2 = (t0 + 2280);
    t3 = (t2 + 32U);
    t6 = *((char **)t3);
    t7 = (t6 + 40U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(35, ng0);
    t9 = (5 * 1000LL);
    t2 = (t0 + 1796);
    xsi_process_wait(t2, t9);

LAB17:    *((char **)t1) = &&LAB18;
    goto LAB1;

LAB12:    goto LAB11;

LAB14:    goto LAB12;

LAB15:    goto LAB5;

LAB16:    goto LAB15;

LAB18:    goto LAB16;

}

static void work_a_3221999106_2762913819_p_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    int64 t7;
    char *t8;
    char *t9;
    unsigned char t10;
    unsigned char t11;

LAB0:    t1 = (t0 + 2040U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(41, ng0);
    t2 = (t0 + 2316);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(42, ng0);
    t2 = (t0 + 2352);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)0;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(44, ng0);
    t7 = (20 * 1000LL);
    t2 = (t0 + 1940);
    xsi_process_wait(t2, t7);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(46, ng0);
    t2 = (t0 + 2316);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(47, ng0);
    t2 = (t0 + 2352);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)1;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(48, ng0);
    t2 = (t0 + 4965);
    t4 = (t0 + 2388);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t8 = (t6 + 40U);
    t9 = *((char **)t8);
    memcpy(t9, t2, 16U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(49, ng0);
    t2 = (t0 + 4981);
    t4 = (t0 + 2424);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    t8 = (t6 + 40U);
    t9 = *((char **)t8);
    memcpy(t9, t2, 7U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(51, ng0);

LAB10:    t2 = (t0 + 2236);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    t3 = (t0 + 2236);
    *((int *)t3) = 0;
    xsi_set_current_line(53, ng0);
    t2 = (t0 + 2352);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)0;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(55, ng0);
    t7 = (60 * 1000LL);
    t2 = (t0 + 1940);
    xsi_process_wait(t2, t7);

LAB14:    *((char **)t1) = &&LAB15;
    goto LAB1;

LAB9:    t3 = (t0 + 868U);
    t4 = *((char **)t3);
    t10 = *((unsigned char *)t4);
    t11 = (t10 <= (unsigned char)1);
    if (t11 == 1)
        goto LAB8;
    else
        goto LAB10;

LAB11:    goto LAB9;

LAB12:    xsi_set_current_line(57, ng0);
    t2 = (t0 + 2460);
    t3 = (t2 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 40U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)0;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(59, ng0);

LAB18:    *((char **)t1) = &&LAB19;
    goto LAB1;

LAB13:    goto LAB12;

LAB15:    goto LAB13;

LAB16:    goto LAB2;

LAB17:    goto LAB16;

LAB19:    goto LAB17;

}


extern void work_a_3221999106_2762913819_init()
{
	static char *pe[] = {(void *)work_a_3221999106_2762913819_p_0,(void *)work_a_3221999106_2762913819_p_1};
	xsi_register_didat("work_a_3221999106_2762913819", "isim/write_line_tb_isim_beh.exe.sim/work/a_3221999106_2762913819.didat");
	xsi_register_executes(pe);
}
