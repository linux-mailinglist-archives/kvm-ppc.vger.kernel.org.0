Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 677C862A40
	for <lists+kvm-ppc@lfdr.de>; Mon,  8 Jul 2019 22:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731951AbfGHUTt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 Jul 2019 16:19:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10184 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729084AbfGHUTs (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 Jul 2019 16:19:48 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x68KHKNZ119319;
        Mon, 8 Jul 2019 16:19:43 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tman04pkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jul 2019 16:19:43 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x68KEi2d009586;
        Mon, 8 Jul 2019 20:19:41 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 2tjk96gha5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jul 2019 20:19:41 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x68KJfki39846248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jul 2019 20:19:41 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6AB3112065;
        Mon,  8 Jul 2019 20:19:40 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89C6E112062;
        Mon,  8 Jul 2019 20:19:39 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  8 Jul 2019 20:19:39 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 08 Jul 2019 15:22:04 -0500
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
Subject: Re: [PATCH v4 6/8] KVM: PPC: Ultravisor: Restrict LDBAR access
Organization: IBM
Reply-To: janani@linux.ibm.com
Mail-Reply-To: janani@linux.ibm.com
In-Reply-To: <20190628200825.31049-7-cclaudio@linux.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com>
 <20190628200825.31049-7-cclaudio@linux.ibm.com>
Message-ID: <fc427393591d1c2a4f23d263179d38f3@linux.vnet.ibm.com>
X-Sender: janani@linux.ibm.com
User-Agent: Roundcube Webmail/1.0.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907080253
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 2019-06-28 15:08, Claudio Carvalho wrote:
> When the ultravisor firmware is available, it takes control over the
> LDBAR register. In this case, thread-imc updates and save/restore
> operations on the LDBAR register are handled by ultravisor.
> 
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
> Reviewed-by: Ram Pai <linuxram@us.ibm.com>
> Reviewed-by: Ryan Grimm <grimm@linux.ibm.com>
> Acked-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
> Acked-by: Paul Mackerras <paulus@ozlabs.org>
  Reviewed-by: Janani Janakiraman <janani@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S   | 2 ++
>  arch/powerpc/platforms/powernv/idle.c     | 6 ++++--
>  arch/powerpc/platforms/powernv/opal-imc.c | 4 ++++
>  3 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> index f9b2620fbecd..cffb365d9d02 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> @@ -375,8 +375,10 @@ BEGIN_FTR_SECTION
>  	mtspr	SPRN_RPR, r0
>  	ld	r0, KVM_SPLIT_PMMAR(r6)
>  	mtspr	SPRN_PMMAR, r0
> +BEGIN_FW_FTR_SECTION_NESTED(70)
>  	ld	r0, KVM_SPLIT_LDBAR(r6)
>  	mtspr	SPRN_LDBAR, r0
> +END_FW_FTR_SECTION_NESTED(FW_FEATURE_ULTRAVISOR, 0, 70)
>  	isync
>  FTR_SECTION_ELSE
>  	/* On P9 we use the split_info for coordinating LPCR changes */
> diff --git a/arch/powerpc/platforms/powernv/idle.c
> b/arch/powerpc/platforms/powernv/idle.c
> index 77f2e0a4ee37..5593a2d55959 100644
> --- a/arch/powerpc/platforms/powernv/idle.c
> +++ b/arch/powerpc/platforms/powernv/idle.c
> @@ -679,7 +679,8 @@ static unsigned long power9_idle_stop(unsigned
> long psscr, bool mmu_on)
>  		sprs.ptcr	= mfspr(SPRN_PTCR);
>  		sprs.rpr	= mfspr(SPRN_RPR);
>  		sprs.tscr	= mfspr(SPRN_TSCR);
> -		sprs.ldbar	= mfspr(SPRN_LDBAR);
> +		if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
> +			sprs.ldbar	= mfspr(SPRN_LDBAR);
> 
>  		sprs_saved = true;
> 
> @@ -762,7 +763,8 @@ static unsigned long power9_idle_stop(unsigned
> long psscr, bool mmu_on)
>  	mtspr(SPRN_PTCR,	sprs.ptcr);
>  	mtspr(SPRN_RPR,		sprs.rpr);
>  	mtspr(SPRN_TSCR,	sprs.tscr);
> -	mtspr(SPRN_LDBAR,	sprs.ldbar);
> +	if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
> +		mtspr(SPRN_LDBAR,	sprs.ldbar);
> 
>  	if (pls >= pnv_first_tb_loss_level) {
>  		/* TB loss */
> diff --git a/arch/powerpc/platforms/powernv/opal-imc.c
> b/arch/powerpc/platforms/powernv/opal-imc.c
> index 1b6932890a73..5fe2d4526cbc 100644
> --- a/arch/powerpc/platforms/powernv/opal-imc.c
> +++ b/arch/powerpc/platforms/powernv/opal-imc.c
> @@ -254,6 +254,10 @@ static int opal_imc_counters_probe(struct
> platform_device *pdev)
>  	bool core_imc_reg = false, thread_imc_reg = false;
>  	u32 type;
> 
> +	/* Disable IMC devices, when Ultravisor is enabled. */
> +	if (firmware_has_feature(FW_FEATURE_ULTRAVISOR))
> +		return -EACCES;
> +
>  	/*
>  	 * Check whether this is kdump kernel. If yes, force the engines to
>  	 * stop and return.
