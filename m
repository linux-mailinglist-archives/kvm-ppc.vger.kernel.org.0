Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0398E12EB9F
	for <lists+kvm-ppc@lfdr.de>; Thu,  2 Jan 2020 23:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgABWDO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 2 Jan 2020 17:03:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23652 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725837AbgABWDO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 2 Jan 2020 17:03:14 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 002M1s5c021298
        for <kvm-ppc@vger.kernel.org>; Thu, 2 Jan 2020 17:03:12 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2x869t798u-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Thu, 02 Jan 2020 17:03:12 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <linuxram@us.ibm.com>;
        Thu, 2 Jan 2020 22:03:10 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 2 Jan 2020 22:03:06 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 002M35Be49152036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jan 2020 22:03:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E957DAE053;
        Thu,  2 Jan 2020 22:03:04 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB647AE045;
        Thu,  2 Jan 2020 22:03:02 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.80.213.131])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  2 Jan 2020 22:03:02 +0000 (GMT)
Date:   Thu, 2 Jan 2020 14:02:59 -0800
From:   Ram Pai <linuxram@us.ibm.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Michael Anderson <andmike@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20191216041924.42318-1-aik@ozlabs.ru>
 <20191216041924.42318-3-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216041924.42318-3-aik@ozlabs.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 20010222-0028-0000-0000-000003CDBF89
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20010222-0029-0000-0000-00002491C611
Message-Id: <20200102220259.GA5556@oc0525413822.ibm.com>
Subject: Re:  [PATCH kernel v2 2/4] powerpc/pseries: Allow not having
 ibm,hypertas-functions::hcall-multi-tce for DDW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-02_07:2020-01-02,2020-01-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 adultscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 suspectscore=48 spamscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001020178
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Dec 16, 2019 at 03:19:22PM +1100, Alexey Kardashevskiy wrote:
> By default a pseries guest supports a H_PUT_TCE hypercall which maps
> a single IOMMU page in a DMA window. Additionally the hypervisor may
> support H_PUT_TCE_INDIRECT/H_STUFF_TCE which update multiple TCEs at once;
> this is advertised via the device tree /rtas/ibm,hypertas-functions
> property which Linux converts to FW_FEATURE_MULTITCE.
> 
> FW_FEATURE_MULTITCE is checked when dma_iommu_ops is used; however
> the code managing the huge DMA window (DDW) ignores it and calls
> H_PUT_TCE_INDIRECT even if it is explicitly disabled via
> the "multitce=off" kernel command line parameter.
> 
> This adds FW_FEATURE_MULTITCE checking to the DDW code path.
> 
> This changes tce_build_pSeriesLP to take liobn and page size as
> the huge window does not have iommu_table descriptor which usually
> the place to store these numbers.
> 
> Fixes: 4e8b0cf46b25 ("powerpc/pseries: Add support for dynamic dma windows")
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
> 
> I've put "Fixes" which is from 2011-02-10 but probably should remove it,
> or otherwise all these "stable backport branch" scripts will react on
> "Fixes" and try pulling this back and we do not really want this as
> this patch won't help anyone with anything useful.
> 
> ---
> Changes:
> v2
> * added "fixes"
> ---
>  arch/powerpc/platforms/pseries/iommu.c | 44 ++++++++++++++++++--------
>  1 file changed, 30 insertions(+), 14 deletions(-)

some minor comments below.

> 
> diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
> index df7db33ca93b..f6e9b87c82fc 100644
> --- a/arch/powerpc/platforms/pseries/iommu.c
> +++ b/arch/powerpc/platforms/pseries/iommu.c
> @@ -132,10 +132,10 @@ static unsigned long tce_get_pseries(struct iommu_table *tbl, long index)
>  	return be64_to_cpu(*tcep);
>  }
> 
> -static void tce_free_pSeriesLP(struct iommu_table*, long, long);
> +static void tce_free_pSeriesLP(unsigned long liobn, long, long);
>  static void tce_freemulti_pSeriesLP(struct iommu_table*, long, long);
> 
> -static int tce_build_pSeriesLP(struct iommu_table *tbl, long tcenum,
> +static int tce_build_pSeriesLP(unsigned long liobn, long tcenum, long tceshift,
>  				long npages, unsigned long uaddr,
>  				enum dma_data_direction direction,
>  				unsigned long attrs)
> @@ -146,25 +146,25 @@ static int tce_build_pSeriesLP(struct iommu_table *tbl, long tcenum,
>  	int ret = 0;
>  	long tcenum_start = tcenum, npages_start = npages;
> 
> -	rpn = __pa(uaddr) >> TCE_SHIFT;
> +	rpn = __pa(uaddr) >> tceshift;
>  	proto_tce = TCE_PCI_READ;
>  	if (direction != DMA_TO_DEVICE)
>  		proto_tce |= TCE_PCI_WRITE;
> 
>  	while (npages--) {
> -		tce = proto_tce | (rpn & TCE_RPN_MASK) << TCE_RPN_SHIFT;
> -		rc = plpar_tce_put((u64)tbl->it_index, (u64)tcenum << 12, tce);
> +		tce = proto_tce | (rpn & TCE_RPN_MASK) << tceshift;
> +		rc = plpar_tce_put((u64)liobn, (u64)tcenum << tceshift, tce);
> 
>  		if (unlikely(rc == H_NOT_ENOUGH_RESOURCES)) {
>  			ret = (int)rc;
> -			tce_free_pSeriesLP(tbl, tcenum_start,
> +			tce_free_pSeriesLP(liobn, tcenum_start,
>  			                   (npages_start - (npages + 1)));
>  			break;
>  		}
> 
>  		if (rc && printk_ratelimit()) {
>  			printk("tce_build_pSeriesLP: plpar_tce_put failed. rc=%lld\n", rc);
> -			printk("\tindex   = 0x%llx\n", (u64)tbl->it_index);
> +			printk("\tindex   = 0x%llx\n", (u64)liobn);
>  			printk("\ttcenum  = 0x%llx\n", (u64)tcenum);
>  			printk("\ttce val = 0x%llx\n", tce );
>  			dump_stack();
> @@ -193,7 +193,8 @@ static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
>  	unsigned long flags;
> 
>  	if ((npages == 1) || !firmware_has_feature(FW_FEATURE_MULTITCE)) {
> -		return tce_build_pSeriesLP(tbl, tcenum, npages, uaddr,
> +		return tce_build_pSeriesLP(tbl->it_index, tcenum,
> +					   tbl->it_page_shift, npages, uaddr,
>  		                           direction, attrs);
>  	}
> 
> @@ -209,8 +210,9 @@ static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
>  		/* If allocation fails, fall back to the loop implementation */
>  		if (!tcep) {
>  			local_irq_restore(flags);
> -			return tce_build_pSeriesLP(tbl, tcenum, npages, uaddr,
> -					    direction, attrs);
> +			return tce_build_pSeriesLP(tbl->it_index, tcenum,
> +					tbl->it_page_shift,
> +					npages, uaddr, direction, attrs);
>  		}
>  		__this_cpu_write(tce_page, tcep);
>  	}
> @@ -261,16 +263,16 @@ static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
>  	return ret;
>  }
> 
> -static void tce_free_pSeriesLP(struct iommu_table *tbl, long tcenum, long npages)
> +static void tce_free_pSeriesLP(unsigned long liobn, long tcenum, long npages)
>  {
>  	u64 rc;
> 
>  	while (npages--) {
> -		rc = plpar_tce_put((u64)tbl->it_index, (u64)tcenum << 12, 0);
> +		rc = plpar_tce_put((u64)liobn, (u64)tcenum << 12, 0);

minor nitpick.  The magic number '12' can be replaced by TCE_SHIFT

> 
>  		if (rc && printk_ratelimit()) {
>  			printk("tce_free_pSeriesLP: plpar_tce_put failed. rc=%lld\n", rc);
> -			printk("\tindex   = 0x%llx\n", (u64)tbl->it_index);
> +			printk("\tindex   = 0x%llx\n", (u64)liobn);
>  			printk("\ttcenum  = 0x%llx\n", (u64)tcenum);
>  			dump_stack();
>  		}
> @@ -285,7 +287,7 @@ static void tce_freemulti_pSeriesLP(struct iommu_table *tbl, long tcenum, long n
>  	u64 rc;
> 
>  	if (!firmware_has_feature(FW_FEATURE_MULTITCE))
> -		return tce_free_pSeriesLP(tbl, tcenum, npages);
> +		return tce_free_pSeriesLP(tbl->it_index, tcenum, npages);
> 
>  	rc = plpar_tce_stuff((u64)tbl->it_index, (u64)tcenum << 12, 0, npages);

Same here.

> 
> @@ -400,6 +402,20 @@ static int tce_setrange_multi_pSeriesLP(unsigned long start_pfn,
>  	u64 rc = 0;
>  	long l, limit;
> 
> +	if (!firmware_has_feature(FW_FEATURE_MULTITCE)) {
> +		unsigned long tceshift = be32_to_cpu(maprange->tce_shift);
> +		unsigned long dmastart = (start_pfn << PAGE_SHIFT) +
> +				be64_to_cpu(maprange->dma_base);
> +		unsigned long tcenum = dmastart >> tceshift;
> +		unsigned long npages = num_pfn << PAGE_SHIFT >>
> +				be32_to_cpu(maprange->tce_shift);
				^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      this can be 'tceshift'. Saves some cpu-cycles.



> +		void *uaddr = __va(start_pfn << PAGE_SHIFT);
> +
> +		return tce_build_pSeriesLP(be32_to_cpu(maprange->liobn),
> +				tcenum, tceshift, npages, (unsigned long) uaddr,
> +				DMA_BIDIRECTIONAL, 0);
> +	}
> +

The code under the if statement, go into a static inline function of its own?


>  	local_irq_disable();	/* to protect tcep and the page behind it */
>  	tcep = __this_cpu_read(tce_page);
> 


Reviewed-by: Ram Pai <linuxram@us.ibm.com>

-- 
Ram Pai

