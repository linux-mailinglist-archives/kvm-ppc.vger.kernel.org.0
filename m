Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B98E1873B1
	for <lists+kvm-ppc@lfdr.de>; Mon, 16 Mar 2020 20:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732464AbgCPT5A (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 16 Mar 2020 15:57:00 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19099 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732436AbgCPT5A (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 16 Mar 2020 15:57:00 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e6fd9db0000>; Mon, 16 Mar 2020 12:56:11 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 16 Mar 2020 12:56:59 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 16 Mar 2020 12:56:59 -0700
Received: from rcampbell-dev.nvidia.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Mar
 2020 19:56:59 +0000
Subject: Re: [PATCH 2/2] mm: remove device private page support from
 hmm_range_fault
To:     Christoph Hellwig <hch@lst.de>
CC:     Jason Gunthorpe <jgg@ziepe.ca>,
        Dan Williams <dan.j.williams@intel.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, <kvm-ppc@vger.kernel.org>,
        <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <nouveau@lists.freedesktop.org>, <linux-mm@kvack.org>
References: <20200316175259.908713-1-hch@lst.de>
 <20200316175259.908713-3-hch@lst.de>
 <c099cc3c-c19f-9d61-4297-2e83df899ca4@nvidia.com>
 <20200316184935.GA25322@lst.de>
X-Nvconfidentiality: public
From:   Ralph Campbell <rcampbell@nvidia.com>
Message-ID: <7e9e22be-dea2-4862-1d05-5285bfc6c066@nvidia.com>
Date:   Mon, 16 Mar 2020 12:56:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200316184935.GA25322@lst.de>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1584388571; bh=hX1AWS8RbjQrpRYPPUApwzR7/6Orzl3RZ5t2Aw26Qm8=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=FWkXqqOomcKpXFpXokXAQN5N4mNXWyUHpZWFwwkjyvP4rXqR8SXCZY+hQqUPSOLVZ
         lIwFVC/PnO6ZESSZGvb5N09xZelYetpUgXDLKuounPcdHpIMiNkjnBP3ymfYmbVkon
         6Xdvsp6ObAjmHrkBYcIH0f5lXfGrufLmg/ag3XzNL/XSgPLFXL3ZiyEr7thCnBXkVG
         noZ7FBf2bxJTZ8/q2a33eRbxwmkWTCHEqGDdT1t9gxZjyeRISiDcKXcP/fRGAjazcp
         /JQnegdK4OF5thEKhVwu3+T85PcM63IhaOKdEInsu0S44w6/F1TlhoRR/oapispC+p
         01vrqwl4yEjhw==
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


On 3/16/20 11:49 AM, Christoph Hellwig wrote:
> On Mon, Mar 16, 2020 at 11:42:19AM -0700, Ralph Campbell wrote:
>>
>> On 3/16/20 10:52 AM, Christoph Hellwig wrote:
>>> No driver has actually used properly wire up and support this feature.
>>> There is various code related to it in nouveau, but as far as I can tell
>>> it never actually got turned on, and the only changes since the initial
>>> commit are global cleanups.
>>
>> This is not actually true. OpenCL 2.x does support SVM with nouveau and
>> device private memory via clEnqueueSVMMigrateMem().
>> Also, Ben Skeggs has accepted a set of patches to map GPU memory after being
>> migrated and this change would conflict with that.
> 
> Can you explain me how we actually invoke this code?

GPU memory is allocated when the device private memory "struct page" is
allocated. See where nouveau_dmem_chunk_alloc() calls nouveau_bo_new().
Then when a page is migrated to the GPU, the GPU memory physical address
is just the offset into the "fake" PFN range allocated by
devm_request_free_mem_region().

I'm looking into allocating GPU memory at the time of migration instead of when
the device private memory struct pages are allocated but that is a future
improvement.

System memory is migrated to GPU memory:
# mesa
clEnqueueSVMMigrateMem()
   svm_migrate_op()
     q.svm_migrate()
       pipe->svm_migrate() // really nvc0_svm_migrate()
         drmCommandWrite() // in libdrm
           drmIoctl()
             ioctl()
               nouveau_drm_ioctl() // nouveau_drm.c
                 drm_ioctl()
                   nouveau_svmm_bind()
                     nouveau_dmem_migrate_vma()
                       migrate_vma_setup()
                       nouveau_dmem_migrate_chunk()
                         nouveau_dmem_migrate_copy_one()
                           // allocate device private struct page
                           dpage = nouveau_dmem_page_alloc_locked()
                             dpage = nouveau_dmem_pages_alloc()
                             // Get GPU VRAM physical address
                             nouveau_dmem_page_addr(dpage)
                             // This does the DMA to GPU memory
                             drm->dmem->migrate.copy_func()
                       migrate_vma_pages()
                       migrate_vma_finalize()

Without my recent patch set, there is no GPU page table entry created for
this migrated memory so there will be a GPU fault which is handled in a
worker thread:
nouveau_svm_fault()
   // examine fault buffer entries and compute range of pages
   nouveau_range_fault()
     // This will fill in the pfns array with a device private entry PFN
     hmm_range_fault()
     // This sees the range->flags[HMM_PFN_DEVICE_PRIVATE] flag
     // and converts the HMM PFN to a GPU physical address
     nouveau_dmem_convert_pfn()
     // This sets up the GPU page tables
     nvif_object_ioctl()

> For that we'd need HMM_PFN_DEVICE_PRIVATE NVIF_VMM_PFNMAP_V0_VRAM
> set in ->pfns before calling hmm_range_fault, which isn't happening.
> 

It is set by hmm_range_fault() via the range->flags[HMM_PFN_DEVICE_PRIVATE] entry
when hmm_range_fault() sees a device private struct page. The call to
nouveau_dmem_convert_pfn() is just replacing the "fake" PFN with the real PFN
but not clearing/changing the read/write or VRAM/system memory PTE bits.
