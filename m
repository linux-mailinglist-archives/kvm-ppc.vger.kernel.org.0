Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A58F96E03
	for <lists+kvm-ppc@lfdr.de>; Wed, 21 Aug 2019 02:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfHUAEj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 20 Aug 2019 20:04:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2964 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726028AbfHUAEj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 20 Aug 2019 20:04:39 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7L01t3S102596;
        Tue, 20 Aug 2019 20:04:33 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ugshjb5ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Aug 2019 20:04:33 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7KNxXYL002059;
        Wed, 21 Aug 2019 00:04:32 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma05wdc.us.ibm.com with ESMTP id 2ue97615e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Aug 2019 00:04:32 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7L04VCA35062050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Aug 2019 00:04:31 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D2D3C6059;
        Wed, 21 Aug 2019 00:04:31 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33AA0C6055;
        Wed, 21 Aug 2019 00:04:31 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.70.94.45])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 21 Aug 2019 00:04:31 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 7CDA02E1100; Tue, 20 Aug 2019 17:04:29 -0700 (PDT)
Date:   Tue, 20 Aug 2019 17:04:29 -0700
From:   Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Claudio Carvalho <cclaudio@linux.ibm.com>, linuxppc-dev@ozlabs.org,
        kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        Guerney Hunt <gdhh@linux.ibm.com>,
        Ryan Grimm <grimm@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 4/7] powerpc/mm: Use UV_WRITE_PATE ucall to register a
 PATE
Message-ID: <20190821000429.GA16695@us.ibm.com>
References: <20190808040555.2371-1-cclaudio@linux.ibm.com>
 <20190808040555.2371-5-cclaudio@linux.ibm.com>
 <871rxo7zif.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871rxo7zif.fsf@concordia.ellerman.id.au>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.10.1 (2018-07-13)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200219
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Michael Ellerman [mpe@ellerman.id.au] wrote:

> Hi Claudio,
> 
> Claudio Carvalho <cclaudio@linux.ibm.com> writes:
> > From: Michael Anderson <andmike@linux.ibm.com>
> >
> > In ultravisor enabled systems, the ultravisor creates and maintains the
> > partition table in secure memory where the hypervisor cannot access, and
>                                    ^
>                                    which?
> 
> > therefore, the hypervisor have to do the UV_WRITE_PATE ucall whenever it
>                             ^          ^
>                             has        a
> > wants to set a partition table entry (PATE).
> >
> > This patch adds the UV_WRITE_PATE ucall and uses it to set a PATE if
> > ultravisor is enabled. Additionally, this also also keeps a copy of the
> > partition table because the nestMMU does not have access to secure
> > memory. Such copy has entries for nonsecure and hypervisor partition.
> 
> I'm having trouble parsing the last sentence there.
> 
> Or at least it doesn't seem to match the code, or I don't understand
> either the code or the comment. More below.

Yes, good catch. We could drop the last sentence. Or maybe change the
last para to:

	This patch adds the UV_WRITE_PATE ucall which is used to update
	the partition table entry (PATE) for a VM (both normal and secure).

	When UV is enabled, the partition table is stored in secure memory
	and can only be accessed via the UV. The HV however maintains a
	copy of the partition table in normal memory to allow NMMU
	translations to occur (for normal VMs). The HV copy includes PATEs
	for secure VMs which would currently be unused (NMMU translations
	cannot access secure memory) but they would be needed as we add
	functionality.

Basically, with UV, PTCR is controlled by the UV and address translations
occur based on the UV's copy of the partition table. (See also:
try_set_ptcr() in "PATCH 5/7 powerpc/mm: Write to PTCR only if ultravisor
disabled")

> 
> > diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
> > index 85bc81abd286..033731f5dbaa 100644
> > --- a/arch/powerpc/mm/book3s64/pgtable.c
> > +++ b/arch/powerpc/mm/book3s64/pgtable.c
> > @@ -213,34 +223,50 @@ void __init mmu_partition_table_init(void)
> >  	powernv_set_nmmu_ptcr(ptcr);
> >  }
> >  
> > -void mmu_partition_table_set_entry(unsigned int lpid, unsigned long dw0,
> > -				   unsigned long dw1)
> > +/*
> > + * Global flush of TLBs and partition table caches for this lpid. The type of
> > + * flush (hash or radix) depends on what the previous use of this partition ID
> > + * was, not the new use.
> > + */
> > +static void flush_partition(unsigned int lpid, unsigned long old_patb0)
> 
> A nicer API would be for the 2nd param to be a "bool radix", and have
> the caller worry about the fact that it comes from (patb0 & PATB_HR).

Agree

> 
> >  {
> > -	unsigned long old = be64_to_cpu(partition_tb[lpid].patb0);
> > -
> > -	partition_tb[lpid].patb0 = cpu_to_be64(dw0);
> > -	partition_tb[lpid].patb1 = cpu_to_be64(dw1);
> > -
> > -	/*
> > -	 * Global flush of TLBs and partition table caches for this lpid.
> > -	 * The type of flush (hash or radix) depends on what the previous
> > -	 * use of this partition ID was, not the new use.
> > -	 */
> >  	asm volatile("ptesync" : : : "memory");
> > -	if (old & PATB_HR) {
> > -		asm volatile(PPC_TLBIE_5(%0,%1,2,0,1) : :
> > +	if (old_patb0 & PATB_HR) {
> > +		asm volatile(PPC_TLBIE_5(%0, %1, 2, 0, 1) : :
> >  			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
> > -		asm volatile(PPC_TLBIE_5(%0,%1,2,1,1) : :
> > +		asm volatile(PPC_TLBIE_5(%0, %1, 2, 1, 1) : :
> 
> That looks like an unrelated whitespace change.
> 
> >  			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
> >  		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 1);
> >  	} else {
> > -		asm volatile(PPC_TLBIE_5(%0,%1,2,0,0) : :
> > +		asm volatile(PPC_TLBIE_5(%0, %1, 2, 0, 0) : :
> 
> Ditto.
> 
> >  			     "r" (TLBIEL_INVAL_SET_LPID), "r" (lpid));
> >  		trace_tlbie(lpid, 0, TLBIEL_INVAL_SET_LPID, lpid, 2, 0, 0);
> >  	}
> >  	/* do we need fixup here ?*/
> >  	asm volatile("eieio; tlbsync; ptesync" : : : "memory");
> >  }
> > +
> > +void mmu_partition_table_set_entry(unsigned int lpid, unsigned long dw0,
> > +				  unsigned long dw1)
> > +{
> > +	unsigned long old = be64_to_cpu(partition_tb[lpid].patb0);
> > +
> > +	partition_tb[lpid].patb0 = cpu_to_be64(dw0);
> > +	partition_tb[lpid].patb1 = cpu_to_be64(dw1);
> 
> ie. here we always update the copy of the partition table, regardless of
> whether we're running under an ultravisor or not. So the copy is a
> complete copy isn't it?

Yes.
> 
> > +	/*
> > +	 * In ultravisor enabled systems, the ultravisor maintains the partition
> > +	 * table in secure memory where we don't have access, therefore, we have
> > +	 * to do a ucall to set an entry.
> > +	 */
> > +	if (firmware_has_feature(FW_FEATURE_ULTRAVISOR)) {
> > +		uv_register_pate(lpid, dw0, dw1);
> > +		pr_info("PATE registered by ultravisor: dw0 = 0x%lx, dw1 = 0x%lx\n",
> > +			dw0, dw1);
> > +	} else {
> > +		flush_partition(lpid, old);
> > +	}
> 
> What is different is whether we flush or not.

only differences are where the partition table used by hardware is stored
(secure memory) and updated (in UV, with higher privilege).

> 
> And don't we still need to do the flush for the nestMMU? I assume we're
> saying the ultravisor will broadcast a flush for us, which will also
> handle the nestMMU case?

The same sequence of instructions (as HV) are used in uv_register_pate()
to flush partition and process scoped entries (so nest MMU would also be
covered when NMMU sees the tlbie?)

Thanks,

Sukadev
