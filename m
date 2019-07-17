Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86696BEB6
	for <lists+kvm-ppc@lfdr.de>; Wed, 17 Jul 2019 17:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfGQO7x (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 17 Jul 2019 10:59:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30696 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725936AbfGQO7x (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 17 Jul 2019 10:59:53 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6HEsGAm054509;
        Wed, 17 Jul 2019 10:59:49 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tt5p08t6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jul 2019 10:59:49 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6HEodhs004635;
        Wed, 17 Jul 2019 14:59:48 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 2tq6x68bqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jul 2019 14:59:48 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6HExlcg37487090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jul 2019 14:59:47 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A54BDAC05E;
        Wed, 17 Jul 2019 14:59:47 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E4DCAC05B;
        Wed, 17 Jul 2019 14:59:47 +0000 (GMT)
Received: from alain (unknown [9.80.221.177])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jul 2019 14:59:47 +0000 (GMT)
Message-ID: <3778dbeb017d642b4f2cfe1cdce63c07209cac14.camel@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 4/8] KVM: PPC: Ultravisor: Use UV_WRITE_PATE ucall to
 register a PATE
From:   Ryan Grimm <grimm@linux.vnet.ibm.com>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>, linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>
Date:   Wed, 17 Jul 2019 10:59:46 -0400
In-Reply-To: <87ims8g24r.fsf@concordia.ellerman.id.au>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com>
         <20190628200825.31049-5-cclaudio@linux.ibm.com>
         <87ims8g24r.fsf@concordia.ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-17_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907170174
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, 2019-07-11 at 22:57 +1000, Michael Ellerman wrote:
> Claudio Carvalho <cclaudio@linux.ibm.com> writes:
> > From: Michael Anderson <andmike@linux.ibm.com>
> > 
> > When running under an ultravisor, the ultravisor controls the real
> > partition table and has it in secure memory where the hypervisor
> > can't
> > access it, and therefore we (the HV) have to do a ucall whenever we
> > want
> > to update an entry.
> > 
> > The HV still keeps a copy of its view of the partition table in
> > normal
> > memory so that the nest MMU can access it.
> > 
> > Both partition tables will have PATE entries for HV and normal
> > virtual
> 
> Can you expand novel acronyms on their first usage please, ie. PATE.
> 

Agreed.  This confused me a while ago.  It is "Partition Table Entry",
correct?

> > machines.
> > 
> > Suggested-by: Ryan Grimm <grimm@linux.vnet.ibm.com>
> 

Please remove this and add 

Reviewed-by: Ryan Grimm <grimm@linux.ibm.com>


> "Suggested" implies this is optional, but it's not :)
> 
> I'm not sure exactly what Ryan's input was, but feel free to make up
> a
> better tag :)
> 
> > Signed-off-by: Michael Anderson <andmike@linux.ibm.com>
> > Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
> > Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> > [ Write the pate in HV's table before doing that in UV's ]
> > Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>
> > ---
> >  arch/powerpc/include/asm/ultravisor-api.h |  5 +++-
> >  arch/powerpc/include/asm/ultravisor.h     | 14 ++++++++++
> >  arch/powerpc/mm/book3s64/hash_utils.c     |  3 +-
> >  arch/powerpc/mm/book3s64/pgtable.c        | 34
> > +++++++++++++++++++++--
> >  arch/powerpc/mm/book3s64/radix_pgtable.c  |  9 ++++--
> >  5 files changed, 57 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/powerpc/include/asm/ultravisor-api.h
> > b/arch/powerpc/include/asm/ultravisor-api.h
> > index 49e766adabc7..141940771add 100644
> > --- a/arch/powerpc/include/asm/ultravisor-api.h
> > +++ b/arch/powerpc/include/asm/ultravisor-api.h
> > @@ -15,6 +15,9 @@
> >  #define U_SUCCESS		H_SUCCESS
> >  #define U_FUNCTION		H_FUNCTION
> >  #define U_PARAMETER		H_PARAMETER
> > +#define U_PERMISSION		H_PERMISSION
> >  
> > -#endif /* _ASM_POWERPC_ULTRAVISOR_API_H */
> 
> What happened there? Just a diff artifact?
> 
> > +/* opcodes */
> > +#define UV_WRITE_PATE			0xF104
> >  
> > +#endif /* _ASM_POWERPC_ULTRAVISOR_API_H */
> > diff --git a/arch/powerpc/include/asm/ultravisor.h
> > b/arch/powerpc/include/asm/ultravisor.h
> > index a78a2dacfd0b..996c1efd6c6d 100644
> > --- a/arch/powerpc/include/asm/ultravisor.h
> > +++ b/arch/powerpc/include/asm/ultravisor.h
> > @@ -12,6 +12,8 @@
> >  
> >  #if !defined(__ASSEMBLY__)
> >  
> > +#include <linux/types.h>
> > +
> >  /* Internal functions */
> >  extern int early_init_dt_scan_ultravisor(unsigned long node, const
> > char *uname,
> >  					 int depth, void *data);
> > @@ -28,8 +30,20 @@ extern int
> > early_init_dt_scan_ultravisor(unsigned long node, const char
> > *uname,
> >   */
> >  #if defined(CONFIG_PPC_POWERNV)
> >  long ucall(unsigned long opcode, unsigned long *retbuf, ...);
> > +#else
> > +static long ucall(unsigned long opcode, unsigned long *retbuf,
> > ...)
> 
>           ^
>           inline
> 
> > +{
> > +	return U_NOT_AVAILABLE;
> > +}
> >  #endif
> 
> That should have been in the previous patch.
> 
> > +static inline int uv_register_pate(u64 lpid, u64 dw0, u64 dw1)
> > +{
> > +	unsigned long retbuf[UCALL_BUFSIZE];
> > +
> > +	return ucall(UV_WRITE_PATE, retbuf, lpid, dw0, dw1);
> 
> You probably want a ucall_norets().
> 
> > +}
> > +
> >  #endif /* !__ASSEMBLY__ */
> >  
> >  #endif	/* _ASM_POWERPC_ULTRAVISOR_H */
> > diff --git a/arch/powerpc/mm/book3s64/hash_utils.c
> > b/arch/powerpc/mm/book3s64/hash_utils.c
> > index 1ff451892d7f..220a4e133240 100644
> > --- a/arch/powerpc/mm/book3s64/hash_utils.c
> > +++ b/arch/powerpc/mm/book3s64/hash_utils.c
> > @@ -1080,9 +1080,10 @@ void hash__early_init_mmu_secondary(void)
> >  
> >  		if (!cpu_has_feature(CPU_FTR_ARCH_300))
> >  			mtspr(SPRN_SDR1, _SDR1);
> > -		else
> > +		else if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
> >  			mtspr(SPRN_PTCR,
> >  			      __pa(partition_tb) | (PATB_SIZE_SHIFT -
> > 12));
> 
> Needs a comment for the else case.
> 
> >  	}
> >  	/* Initialize SLB */
> >  	slb_initialize();
> > diff --git a/arch/powerpc/mm/book3s64/pgtable.c
> > b/arch/powerpc/mm/book3s64/pgtable.c
> > index ad3dd977c22d..224c5c7c2e3d 100644
> > --- a/arch/powerpc/mm/book3s64/pgtable.c
> > +++ b/arch/powerpc/mm/book3s64/pgtable.c
> > @@ -16,6 +16,8 @@
> >  #include <asm/tlb.h>
> >  #include <asm/trace.h>
> >  #include <asm/powernv.h>
> > +#include <asm/firmware.h>
> > +#include <asm/ultravisor.h>
> >  
> >  #include <mm/mmu_decl.h>
> >  #include <trace/events/thp.h>
> > @@ -206,12 +208,25 @@ void __init mmu_partition_table_init(void)
> >  	 * 64 K size.
> >  	 */
> >  	ptcr = __pa(partition_tb) | (PATB_SIZE_SHIFT - 12);
> > -	mtspr(SPRN_PTCR, ptcr);
> > +	/*
> > +	 * If ultravisor is available, it is responsible for creating
> > and
> > +	 * managing partition table
> > +	 */
> 
> But we just created the partition table?!
> 
> This comment and the one below would probably make more sense if they
> were merged and appeared further up, where we allocate the partition
> table.
>       
> > +	if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
> > +		mtspr(SPRN_PTCR, ptcr);
> > +
> > +	/*
> > +	 * Since nestMMU cannot access secure memory. Create
> > +	 * and manage our own partition table. This table
> 
> But we just said the UV was responsible for it :)
> 
> > +	 * contains entries for nonsecure and hypervisor
> > +	 * partition.
> > +	 */
> >  	powernv_set_nmmu_ptcr(ptcr);
> >  }
> >  
> > -void mmu_partition_table_set_entry(unsigned int lpid, unsigned
> > long dw0,
> > -				   unsigned long dw1)
> > +static void __mmu_partition_table_set_entry(unsigned int lpid,
> > +					    unsigned long dw0,
> > +					    unsigned long dw1)
> >  {
> >  	unsigned long old = be64_to_cpu(partition_tb[lpid].patb0);
> >  
> > @@ -238,6 +253,19 @@ void mmu_partition_table_set_entry(unsigned
> > int lpid, unsigned long dw0,
> >  	/* do we need fixup here ?*/
> >  	asm volatile("eieio; tlbsync; ptesync" : : : "memory");
> >  }
> > +
> > +void mmu_partition_table_set_entry(unsigned int lpid, unsigned
> > long dw0,
> > +				  unsigned long dw1)
> > +{
> > +	__mmu_partition_table_set_entry(lpid, dw0, dw1);
> > +
> > +	if (firmware_has_feature(FW_FEATURE_ULTRAVISOR)) {
> > +		uv_register_pate(lpid, dw0, dw1);
> > +		pr_info("PATE registered by ultravisor: dw0 = 0x%lx,
> > dw1 = 0x%lx\n",
> > +			dw0, dw1);
> > +	}
> > +}
> 
> I agree with Alexey that this patch and the next should be merged and
> the result cleaned up a bit.
> 
> > +
> 
> No extra blank please.
> 
> >  EXPORT_SYMBOL_GPL(mmu_partition_table_set_entry);
> >  
> >  static pmd_t *get_pmd_from_cache(struct mm_struct *mm)
> > diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c
> > b/arch/powerpc/mm/book3s64/radix_pgtable.c
> > index 8904aa1243d8..da6a6b76a040 100644
> > --- a/arch/powerpc/mm/book3s64/radix_pgtable.c
> > +++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
> > @@ -656,8 +656,10 @@ void radix__early_init_mmu_secondary(void)
> >  		lpcr = mfspr(SPRN_LPCR);
> >  		mtspr(SPRN_LPCR, lpcr | LPCR_UPRT | LPCR_HR);
> >  
> > -		mtspr(SPRN_PTCR,
> > -		      __pa(partition_tb) | (PATB_SIZE_SHIFT - 12));
> > +		if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
> > +			mtspr(SPRN_PTCR, __pa(partition_tb) |
> > +			      (PATB_SIZE_SHIFT - 12));
> > +
> >  		radix_init_amor();
> >  	}
> >  
> > @@ -673,7 +675,8 @@ void radix__mmu_cleanup_all(void)
> >  	if (!firmware_has_feature(FW_FEATURE_LPAR)) {
> >  		lpcr = mfspr(SPRN_LPCR);
> >  		mtspr(SPRN_LPCR, lpcr & ~LPCR_UPRT);
> > -		mtspr(SPRN_PTCR, 0);
> > +		if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
> > +			mtspr(SPRN_PTCR, 0);
> >  		powernv_set_nmmu_ptcr(0);
> >  		radix__flush_tlb_all();
> >  	}
> 
> There's four of these case where we skip touching the PTCR, which is
> right on the borderline of warranting an accessor. I guess we can do
> it
> as a cleanup later.
> 
> cheers
> 

