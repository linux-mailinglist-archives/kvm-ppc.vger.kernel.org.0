Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A784629E7
	for <lists+kvm-ppc@lfdr.de>; Mon,  8 Jul 2019 21:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbfGHTwf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 8 Jul 2019 15:52:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11114 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727163AbfGHTwf (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 8 Jul 2019 15:52:35 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x68JkwWG078575;
        Mon, 8 Jul 2019 15:52:29 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tmbg5htwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jul 2019 15:52:29 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x68JmrMe014650;
        Mon, 8 Jul 2019 19:52:28 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 2tjk968c35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jul 2019 19:52:28 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x68JqRYc59048408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jul 2019 19:52:27 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14492136051;
        Mon,  8 Jul 2019 19:52:27 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EB1613604F;
        Mon,  8 Jul 2019 19:52:26 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  8 Jul 2019 19:52:26 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 08 Jul 2019 14:54:52 -0500
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
Subject: Re: [PATCH v4 5/8] KVM: PPC: Ultravisor: Restrict flush of the
 partition tlb cache
Organization: IBM
Reply-To: janani@linux.ibm.com
Mail-Reply-To: janani@linux.ibm.com
In-Reply-To: <20190628200825.31049-6-cclaudio@linux.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com>
 <20190628200825.31049-6-cclaudio@linux.ibm.com>
Message-ID: <134bd0eb97ed6cc616ced38732b9b52c@linux.vnet.ibm.com>
X-Sender: janani@linux.ibm.com
User-Agent: Roundcube Webmail/1.0.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907080245
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 2019-06-28 15:08, Claudio Carvalho wrote:
> From: Ram Pai <linuxram@us.ibm.com>
> 
> Ultravisor is responsible for flushing the tlb cache, since it manages
> the PATE entries. Hence skip tlb flush, if the ultravisor firmware is
> available.
> 
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
> ---
>  arch/powerpc/mm/book3s64/pgtable.c | 33 +++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/powerpc/mm/book3s64/pgtable.c
> b/arch/powerpc/mm/book3s64/pgtable.c
> index 224c5c7c2e3d..bc8eb2bf9810 100644
> --- a/arch/powerpc/mm/book3s64/pgtable.c
> +++ b/arch/powerpc/mm/book3s64/pgtable.c
> @@ -224,6 +224,23 @@ void __init mmu_partition_table_init(void)
>  	powernv_set_nmmu_ptcr(ptcr);
>  }
> 
> +static void flush_partition(unsigned int lpid, unsigned long dw0)
> +{
> +	if (dw0 & PATB_HR) {
> +		asm volatile(PPC_TLBIE_5(%0, %1, 2, 0, 1) : :
> +			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
> +		asm volatile(PPC_TLBIE_5(%0, %1, 2, 1, 1) : :
> +			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
> +		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 1);
> +	} else {
> +		asm volatile(PPC_TLBIE_5(%0, %1, 2, 0, 0) : :
> +			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
> +		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 0);
> +	}
> +	/* do we need fixup here ?*/
> +	asm volatile("eieio; tlbsync; ptesync" : : : "memory");
> +}
> +
>  static void __mmu_partition_table_set_entry(unsigned int lpid,
>  					    unsigned long dw0,
>  					    unsigned long dw1)
> @@ -238,20 +255,8 @@ static void
> __mmu_partition_table_set_entry(unsigned int lpid,
>  	 * The type of flush (hash or radix) depends on what the previous
>  	 * use of this partition ID was, not the new use.
>  	 */
> -	asm volatile("ptesync" : : : "memory");
  Doesn't the line above that was deleted need to be added to the 
beginning of flush_partition()
> -	if (old & PATB_HR) {
> -		asm volatile(PPC_TLBIE_5(%0,%1,2,0,1) : :
> -			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
> -		asm volatile(PPC_TLBIE_5(%0,%1,2,1,1) : :
> -			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
> -		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 1);
> -	} else {
> -		asm volatile(PPC_TLBIE_5(%0,%1,2,0,0) : :
> -			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
> -		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 0);
> -	}
> -	/* do we need fixup here ?*/
> -	asm volatile("eieio; tlbsync; ptesync" : : : "memory");
> +	if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
> +		flush_partition(lpid, old);
>  }
> 
>  void mmu_partition_table_set_entry(unsigned int lpid, unsigned long 
> dw0,
