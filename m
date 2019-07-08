Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF8362752
	for <lists+kvm-ppc@lfdr.de>; Mon,  8 Jul 2019 19:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbfGHRgO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 Jul 2019 13:36:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41340 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726997AbfGHRgO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 Jul 2019 13:36:14 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x68HY7Va118212
        for <kvm-ppc@vger.kernel.org>; Mon, 8 Jul 2019 13:36:12 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tma9508d6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Mon, 08 Jul 2019 13:36:12 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <janani@linux.ibm.com>;
        Mon, 8 Jul 2019 18:36:12 +0100
Received: from b01cxnp22036.gho.pok.ibm.com (9.57.198.26)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 8 Jul 2019 18:36:09 +0100
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x68Ha8Qs34734410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jul 2019 17:36:08 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B90EAC05E;
        Mon,  8 Jul 2019 17:36:08 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C490AC059;
        Mon,  8 Jul 2019 17:36:07 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  8 Jul 2019 17:36:07 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 08 Jul 2019 12:38:32 -0500
From:   janani <janani@linux.ibm.com>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>
Cc:     linuxppc-dev@ozlabs.org, kvm-ppc@vger.kernel.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>
Subject: Re: [PATCH v4 1/8] KVM: PPC: Ultravisor: Introduce the MSR_S bit
Organization: IBM
Reply-To: janani@linux.ibm.com
Mail-Reply-To: janani@linux.ibm.com
In-Reply-To: <20190628200825.31049-2-cclaudio@linux.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com>
 <20190628200825.31049-2-cclaudio@linux.ibm.com>
X-Sender: janani@linux.ibm.com
User-Agent: Roundcube Webmail/1.0.1
X-TM-AS-GCONF: 00
x-cbid: 19070817-0052-0000-0000-000003DBD376
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011397; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01229301; UDB=6.00647407; IPR=6.01010561;
 MB=3.00027636; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-08 17:36:11
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070817-0053-0000-0000-0000619D051D
Message-Id: <ccd9bdbcc2e4dad9f8c2e7acbb222d5e@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=891 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907080216
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 2019-06-28 15:08, Claudio Carvalho wrote:
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> 
> The ultravisor processor mode is introduced in POWER platforms that
> supports the Protected Execution Facility (PEF). Ultravisor is higher
> privileged than hypervisor mode.
> 
> In PEF enabled platforms, the MSR_S bit is used to indicate if the
> thread is in secure state. With the MSR_S bit, the privilege state of
> the thread is now determined by MSR_S, MSR_HV and MSR_PR, as follows:
> 
> S   HV  PR
> -----------------------
> 0   x   1   problem
> 1   0   1   problem
> x   x   0   privileged
> x   1   0   hypervisor
> 1   1   0   ultravisor
> 1   1   1   reserved
> 
> The hypervisor doesn't (and can't) run with the MSR_S bit set, but a
> secure guest and the ultravisor firmware do.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> [ Update the commit message ]
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
  Reviewed-by: Janani Janakiraman <janani@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/reg.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/reg.h 
> b/arch/powerpc/include/asm/reg.h
> index 10caa145f98b..39b4c0a519f5 100644
> --- a/arch/powerpc/include/asm/reg.h
> +++ b/arch/powerpc/include/asm/reg.h
> @@ -38,6 +38,7 @@
>  #define MSR_TM_LG	32		/* Trans Mem Available */
>  #define MSR_VEC_LG	25	        /* Enable AltiVec */
>  #define MSR_VSX_LG	23		/* Enable VSX */
> +#define MSR_S_LG	22		/* Secure VM bit */
>  #define MSR_POW_LG	18		/* Enable Power Management */
>  #define MSR_WE_LG	18		/* Wait State Enable */
>  #define MSR_TGPR_LG	17		/* TLB Update registers in use */
> @@ -71,11 +72,13 @@
>  #define MSR_SF		__MASK(MSR_SF_LG)	/* Enable 64 bit mode */
>  #define MSR_ISF		__MASK(MSR_ISF_LG)	/* Interrupt 64b mode valid on 630 
> */
>  #define MSR_HV 		__MASK(MSR_HV_LG)	/* Hypervisor state */
> +#define MSR_S		__MASK(MSR_S_LG)	/* Secure state */
>  #else
>  /* so tests for these bits fail on 32-bit */
>  #define MSR_SF		0
>  #define MSR_ISF		0
>  #define MSR_HV		0
> +#define MSR_S		0
>  #endif
> 
>  /*

