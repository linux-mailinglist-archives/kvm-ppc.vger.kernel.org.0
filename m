Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65EEB11EBDA
	for <lists+kvm-ppc@lfdr.de>; Fri, 13 Dec 2019 21:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbfLMUdG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 13 Dec 2019 15:33:06 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54050 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728997AbfLMUdG (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 13 Dec 2019 15:33:06 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBDKWflo123905
        for <kvm-ppc@vger.kernel.org>; Fri, 13 Dec 2019 15:33:05 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wusvjcb5u-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Fri, 13 Dec 2019 15:33:05 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <linuxram@us.ibm.com>;
        Fri, 13 Dec 2019 20:33:02 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 13 Dec 2019 20:33:00 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBDKWxtb40173952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 20:33:00 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDF0011C052;
        Fri, 13 Dec 2019 20:32:59 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2728711C04A;
        Fri, 13 Dec 2019 20:32:58 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.80.213.32])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 13 Dec 2019 20:32:57 +0000 (GMT)
Date:   Fri, 13 Dec 2019 12:32:55 -0800
From:   Ram Pai <linuxram@us.ibm.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20191213084537.27306-1-aik@ozlabs.ru>
 <20191213084537.27306-3-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213084537.27306-3-aik@ozlabs.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19121320-0016-0000-0000-000002D4936B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121320-0017-0000-0000-00003336C08E
Message-Id: <20191213203255.GE5702@oc0525413822.ibm.com>
Subject: Re:  [PATCH kernel 2/3] powerpc/pseries: Allow not having
 ibm,hypertas-functions::hcall-multi-tce for DDW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_07:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 clxscore=1015 suspectscore=48 adultscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130151
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Dec 13, 2019 at 07:45:36PM +1100, Alexey Kardashevskiy wrote:
> By default a pseries guest supports a H_PUT_TCE hypercall which maps
> a single IOMMU page in a DMA window. Additionally the hypervisor may
> support H_PUT_TCE_INDIRECT/H_STUFF_TCE which update multiple TCEs at once;
> this is advertised via the device tree /rtas/ibm,hypertas-functions
> property which Linux converts to FW_FEATURE_MULTITCE.

Thanks Alexey for the patches!

> 
> FW_FEATURE_MULTITCE is checked when dma_iommu_ops is used; however
> the code managing the huge DMA window (DDW) ignores it and calls
> H_PUT_TCE_INDIRECT even if it is explicitly disabled via
> the "multitce=off" kernel command line parameter.

Also H_PUT_TCE_INDIRECT should not be called in secure VM, even when
"multitce=on".  right? Or does it get disabled somehow in the 
secure guest?


> 
> This adds FW_FEATURE_MULTITCE checking to the DDW code path.
> 
> This changes tce_build_pSeriesLP to take liobn and page size as
> the huge window does not have iommu_table descriptor which usually
> the place to store these numbers.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
> 
> The idea is then set FW_FEATURE_MULTITCE in init_svm() and have the guest

I think, you mean unset FW_FEATURE_MULTITCE.

> use H_PUT_TCE without sharing a (temporary) page for H_PUT_TCE_INDIRECT.
> ---
>  arch/powerpc/platforms/pseries/iommu.c | 44 ++++++++++++++++++--------
>  1 file changed, 30 insertions(+), 14 deletions(-)
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
> 
> @@ -400,6 +402,20 @@ static int tce_setrange_multi_pSeriesLP(unsigned long start_pfn,
>  	u64 rc = 0;
>  	long l, limit;
> 
> +	if (!firmware_has_feature(FW_FEATURE_MULTITCE)) {

this code should execute in  secure guest. Which means we need a
	' || is_secure_guest() '   check.


> +		unsigned long tceshift = be32_to_cpu(maprange->tce_shift);
> +		unsigned long dmastart = (start_pfn << PAGE_SHIFT) +
> +				be64_to_cpu(maprange->dma_base);
> +		unsigned long tcenum = dmastart >> tceshift;
> +		unsigned long npages = num_pfn << PAGE_SHIFT >>
> +				be32_to_cpu(maprange->tce_shift);
> +		void *uaddr = __va(start_pfn << PAGE_SHIFT);
> +
> +		return tce_build_pSeriesLP(be32_to_cpu(maprange->liobn),
> +				tcenum, tceshift, npages, (unsigned long) uaddr,
> +				DMA_BIDIRECTIONAL, 0);
> +	}
> +
>  	local_irq_disable();	/* to protect tcep and the page behind it */
>  	tcep = __this_cpu_read(tce_page);

RP

