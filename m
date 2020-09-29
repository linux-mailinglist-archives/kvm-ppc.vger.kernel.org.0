Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD9127BB39
	for <lists+kvm-ppc@lfdr.de>; Tue, 29 Sep 2020 05:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgI2DAP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 28 Sep 2020 23:00:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39594 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727226AbgI2DAO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 28 Sep 2020 23:00:14 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08T2WUxo170825;
        Mon, 28 Sep 2020 22:59:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : in-reply-to; s=pp1; bh=5ZRM/KDpvesPWf69Rz9gnZHLps4Dc84U5HBJCv1mi6A=;
 b=Mkh8x/+u0Rgbksw7uC63ujkhldesHM6hn2XcZz8bcZoh510CmC+pzIgwgSSm5a6Ae4tQ
 bHyO8I8eDYFhKKKninC9aaN4kiRlYDJYQDFDqteltPLiEn/nOmvGEFOhUkB7PmuKzH6I
 M9Oj8DYTpDhuL32usmveCoZvifF6AjpiFKnObtTet4Z19gvWqpcibFfbLSNYAooPcuSi
 bUpjr9da/TnjQYV8Tvt2Tx8S1i+XbUGVCGMsYIPdg3w4cnlUQLh0nAgYBoVtxetlwBye
 9RMyOdfzMeqbW46KMmeqKCIw/ZTq0rsI/8zbgWzFQ7dRbAtq2KLZsPkKwK/uxWZFhOFl oA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33uuk2sc84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 22:59:52 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08T2xpXN044389;
        Mon, 28 Sep 2020 22:59:51 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33uuk2sc7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 22:59:51 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08T2upkk019473;
        Tue, 29 Sep 2020 02:59:49 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 33sw981dw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 02:59:49 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08T2xljm26935674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 02:59:47 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48D80A4053;
        Tue, 29 Sep 2020 02:59:47 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39DE8A4040;
        Tue, 29 Sep 2020 02:59:44 +0000 (GMT)
Received: from in.ibm.com (unknown [9.199.52.162])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 29 Sep 2020 02:59:44 +0000 (GMT)
Date:   Tue, 29 Sep 2020 08:29:41 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     linux-mm@kvack.org, kvm-ppc@vger.kernel.org,
        nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Jerome Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>, Zi Yan <ziy@nvidia.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mm: remove extra ZONE_DEVICE struct page refcount
Message-ID: <20200929025941.GA257792@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <20200925204442.31348-1-rcampbell@nvidia.com>
 <20200925204442.31348-3-rcampbell@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925204442.31348-3-rcampbell@nvidia.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-28_25:2020-09-28,2020-09-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 bulkscore=0 clxscore=1011 malwarescore=0 phishscore=0 suspectscore=1
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290019
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Sep 25, 2020 at 01:44:42PM -0700, Ralph Campbell wrote:
> ZONE_DEVICE struct pages have an extra reference count that complicates the
> code for put_page() and several places in the kernel that need to check the
> reference count to see that a page is not being used (gup, compaction,
> migration, etc.). Clean up the code so the reference count doesn't need to
> be treated specially for ZONE_DEVICE.
> 
> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> ---
>  arch/powerpc/kvm/book3s_hv_uvmem.c     |  2 +-
>  drivers/gpu/drm/nouveau/nouveau_dmem.c |  2 +-
>  include/linux/dax.h                    |  2 +-
>  include/linux/memremap.h               |  7 ++-
>  include/linux/mm.h                     | 44 --------------
>  lib/test_hmm.c                         |  2 +-
>  mm/gup.c                               | 44 --------------
>  mm/internal.h                          |  8 +++
>  mm/memremap.c                          | 82 ++++++--------------------
>  mm/migrate.c                           |  5 --
>  mm/page_alloc.c                        |  3 +
>  mm/swap.c                              | 46 +++------------
>  12 files changed, 44 insertions(+), 203 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
> index 7705d5557239..e6ec98325fab 100644
> --- a/arch/powerpc/kvm/book3s_hv_uvmem.c
> +++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
> @@ -711,7 +711,7 @@ static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
>  
>  	dpage = pfn_to_page(uvmem_pfn);
>  	dpage->zone_device_data = pvt;
> -	get_page(dpage);
> +	init_page_count(dpage);

The powerpc change looks good. Passes a quick sanity test of
booting/rebooting a secure guest on Power.

Tested-by: Bharata B Rao <bharata@linux.ibm.com>

Regards,
Bharata.
