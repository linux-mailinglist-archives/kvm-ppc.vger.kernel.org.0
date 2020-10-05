Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E4A283E40
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Oct 2020 20:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgJESYU (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 5 Oct 2020 14:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbgJESYU (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 5 Oct 2020 14:24:20 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32A6C0613A7
        for <kvm-ppc@vger.kernel.org>; Mon,  5 Oct 2020 11:24:19 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id c62so13078319qke.1
        for <kvm-ppc@vger.kernel.org>; Mon, 05 Oct 2020 11:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OCSLqGNh9b5YSmYsk1DlWKJeyULS7OR1a85rgALsc9w=;
        b=MCDa+1cwmN3uqvhljUtqnjRDTYQZ/bi0REuAsgRPHawGFRLu9yuU9WlllBKYKSYWoC
         COppqAsu3MTAife2gP8sPBj5BM2BbGaDJxEwZvtuafwP4a4hdfpwdn/NGDE42M6wmPYx
         w6RKz8PK1yLHK6fqWqsgZhdkxQJNKhX5RC2wxagFLtzU3TwNIOuknrBo7berTriabUSB
         qqTiGv8KasNRDd1sfsDjr2lO2IxW1f9KChgBRQcBUplHmmgGaWF66ZIebhDq1VNBfLXS
         ScC9FSdcE4fiChkQkPfTWWSWJq5i1UZonfVL4S1jsX1F1gH31b2ZbJ02j2EKwtYWInDJ
         gSCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OCSLqGNh9b5YSmYsk1DlWKJeyULS7OR1a85rgALsc9w=;
        b=ACmGOY30DID0WkKOASQcdhXScJRSvfACVpDeIleJ5h4J5Rqrv4lwHIuTFSLCgPqCGd
         GBCw2Wf+GRYldjyvcDG8r5A38PjmKf7+8nccWnZTzVTQhgJ+tyfeGHpKj5RgDFwT/R5d
         wjWd9kd+HLgCvFHc165aRh0Sk2XPY94YJ/Dsa+WjvUwKdLGl00oqYcrmH9m8Euvy28LL
         h3bsuoUUvfyORSUKxoaCXoicPMi6bSkc3efPArsxpNg/e4MiA/rJBZaeqGnfwJPUAnev
         Akx3GkZ9Vvl9y8UjZcd33StdEvNNPTkJPuGvFiV5Qn7Edk8X3GCdaHn6nbPuEzgbRbVb
         0w0A==
X-Gm-Message-State: AOAM5332F0vLY2dNvipZRlgZrwjLj6pbhFF7FShDMv+qRxFEACbYFxsG
        yleTTFRyMd5k0t4zXM0cyDutA4QxMul49UfMYG3q7A==
X-Google-Smtp-Source: ABdhPJxukAgIYi20kSI9kjVPF33fEc4rKpb9eQYgj02bTfT4kUplSjOE1HGcZ8LTlpn7FoBl8beo3/6xylx4QC83AAg=
X-Received: by 2002:a05:620a:4d0:: with SMTP id 16mr1333224qks.200.1601922258954;
 Mon, 05 Oct 2020 11:24:18 -0700 (PDT)
MIME-Version: 1.0
References: <20201001181715.17416-1-rcampbell@nvidia.com>
In-Reply-To: <20201001181715.17416-1-rcampbell@nvidia.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 5 Oct 2020 11:24:07 -0700
Message-ID: <CAPcyv4gu=So5PgQU9LezhW4vUQt+paaUr1T6CAvQYjh0XzkkgQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/2] mm: remove extra ZONE_DEVICE struct page refcount
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     Linux MM <linux-mm@kvack.org>, kvm-ppc@vger.kernel.org,
        nouveau@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ira Weiny <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Jerome Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Zi Yan <ziy@nvidia.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Oct 1, 2020 at 11:17 AM Ralph Campbell <rcampbell@nvidia.com> wrote:
>
> This is still an RFC because after looking at the pmem/dax code some
> more, I realized that the ZONE_DEVICE struct pages are being inserted
> into the process' page tables with vmf_insert_mixed() and a zero
> refcount on the ZONE_DEVICE struct page. This is sort of OK because
> insert_pfn() increments the reference count on the pgmap which is what
> prevents memunmap_pages() from freeing the struct pages and it doesn't
> check for a non-zero struct page reference count.
> But, any calls to get_page() will hit the VM_BUG_ON_PAGE() that
> checks for a reference count == 0.
>
> // mmap() an ext4 file that is mounted -o dax.
> ext4_dax_fault()
>   ext4_dax_huge_fault()
>     dax_iomap_fault(&ext4_iomap_ops)
>       dax_iomap_pte_fault()
>         ops->iomap_begin() // ext4_iomap_begin()
>           ext4_map_blocks()
>           ext4_set_iomap()
>         dax_iomap_pfn()
>         dax_insert_entry()
>         vmf_insert_mixed(pfn)
>           __vm_insert_mixed()
>             if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL) &&
>                 !pfn_t_devmap(pfn) && pfn_t_valid(pfn))
>               insert_page()
>                 get_page(page) // XXX would trigger VM_BUG_ON_PAGE()
>                 page_add_file_rmap()
>                 set_pte_at()
>             else
>               insert_pfn()
>                 pte_mkdevmap()
>                 set_pte_at()
>
> Should pmem set the page reference count to one before inserting the
> pfn into the page tables (and decrement when removing devmap PTEs)?
> What about MEMORY_DEVICE_GENERIC and MEMORY_DEVICE_PCI_P2PDMA use cases?
> Where should they icrement/decrement the page reference count?
> I don't know enough about how these are used to really know what to
> do at this point. If people want me to continue to work on this series,
> I will need some guidance.

fs/dax could take the reference when inserting, but that would mean
that ext4 and xfs would need to go back to checking for 1 to be page
idle. I think that's ok because the filesystem is actually not
checking for page-idle it's checking for "get_user_pages()" idle.
