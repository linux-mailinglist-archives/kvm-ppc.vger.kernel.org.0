Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259CA31DF70
	for <lists+kvm-ppc@lfdr.de>; Wed, 17 Feb 2021 20:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhBQTMf (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 17 Feb 2021 14:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbhBQTMe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 17 Feb 2021 14:12:34 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB7EC061574
        for <kvm-ppc@vger.kernel.org>; Wed, 17 Feb 2021 11:11:54 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id f18so6797614qvm.9
        for <kvm-ppc@vger.kernel.org>; Wed, 17 Feb 2021 11:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :organization:user-agent:mime-version:content-transfer-encoding;
        bh=u4lbCYpxz+ZW5VAXp7OqgJphBLt/2DDRqGDYxIl7pCc=;
        b=GOByrHDKbf0jo9325LAy11eGu9UdGoSHB9Zh3C2GU4OV/B8tgkmYuHvwtkbTuvmyyY
         U0iWJrYrbndtqw4mZNoFuuSH+XfX+AxOt60BsjIpkbFcGN1EfT5XIUtYgZViurCXoHPt
         uxsld3bU42RukC+lugT01ll25f246GpKu4SK+ccgEWbbWxEGCzc5sRGUieFMkKmmOe09
         PfBzvCeykj3h1u7qDabvXa33UAR53LQXQjk5POzozIK21xxmwHqKclqdX0vK1GyUxVLH
         5LbF+osfrOegLt2XKCfyAb5XAbbfC/JzSjfwN/M6AnHdbZy/PDXfN2AB8yxBJCO5KF0f
         lIhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=u4lbCYpxz+ZW5VAXp7OqgJphBLt/2DDRqGDYxIl7pCc=;
        b=SbKFxI4BTy7kDbsaKMgcF4JYjsxc3dfINeBnGECee2hdO777zLYVL/oMGz0ESL9v4f
         zQ50cXBvOLAfWy9tq3S/Xy8n2H86Na+insrL1q/Zlv+bZvsRo8LJs3HeRyPpUJkypvKR
         Eb4yguG9+1jyvda6NaZ00LEQgPac7zz+MGhDOfE7PF7Jwjhn7vkOnlE6AKQl1kTNN0dw
         SrMHl2zjimA4kzMMWCDcNJf7TpD8s6Q3B63ylk43gXJy+RQUibD1oWtC72enFsXJkVpY
         qwnMRVwOWIudbE/bw4qn3OVIaajzxonmiWKJqFct4Pgq376cRgPKe5C0CnKIhHnIXL2b
         g+8A==
X-Gm-Message-State: AOAM531skBl1nL5bYZkrKW/j/sEkPFfjPSF8Q2G/0lbEnaAxjJ0QTxH4
        UQfZZyEsIL3pjY7GhcatrTna2VE7xso=
X-Google-Smtp-Source: ABdhPJwDTvge1o7b1Uh8lOtIDvJQAvRXNImlZe19CNHjy6g6sOnFGEudFsgHsOfPSYgA80H+olQJlA==
X-Received: by 2002:a0c:e085:: with SMTP id l5mr769758qvk.38.1613589113366;
        Wed, 17 Feb 2021 11:11:53 -0800 (PST)
Received: from li-908e0a4c-2250-11b2-a85c-f027e903211b.ibm.com (177-131-90-207.dynamic.desktop.com.br. [177.131.90.207])
        by smtp.gmail.com with ESMTPSA id s14sm1782694qtq.97.2021.02.17.11.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 11:11:52 -0800 (PST)
Message-ID: <05859751d16e39500cf16641f5578ec5e294afb5.camel@gmail.com>
Subject: Re: [PATCH kernel 1/2] powerpc/iommu: Allocate it_map by vmalloc
From:   Leonardo Bras <leobras.c@gmail.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Date:   Wed, 17 Feb 2021 16:11:48 -0300
In-Reply-To: <20210216033307.69863-2-aik@ozlabs.ru>
References: <20210216033307.69863-1-aik@ozlabs.ru>
         <20210216033307.69863-2-aik@ozlabs.ru>
Organization: IBM
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, 2021-02-16 at 14:33 +1100, Alexey Kardashevskiy wrote:
> The IOMMU table uses the it_map bitmap to keep track of allocated DMA
> pages. This has always been a contiguous array allocated at either
> the boot time or when a passed through device is returned to the host OS.
> The it_map memory is allocated by alloc_pages() which allocates
> contiguous physical memory.
> 
> Such allocation method occasionally creates a problem when there is
> no big chunk of memory available (no free memory or too fragmented).
> On powernv/ioda2 the default DMA window requires 16MB for it_map.
> 
> This replaces alloc_pages_node() with vzalloc_node() which allocates
> contiguous block but in virtual memory. This should reduce changes of
> failure but should not cause other behavioral changes as it_map is only
> used by the kernel's DMA hooks/api when MMU is on.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

It looks a very good change, and also makes code much simpler to read.

FWIW:

Reviewed-by: Leonardo Bras <leobras.c@gmail,com>

> ---
>  arch/powerpc/kernel/iommu.c | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
> index c00214a4355c..8eb6eb0afa97 100644
> --- a/arch/powerpc/kernel/iommu.c
> +++ b/arch/powerpc/kernel/iommu.c
> @@ -719,7 +719,6 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid,
>  {
>  	unsigned long sz;
>  	static int welcomed = 0;
> -	struct page *page;
>  	unsigned int i;
>  	struct iommu_pool *p;
>  
> 
> 
> 
> @@ -728,11 +727,9 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid,
>  	/* number of bytes needed for the bitmap */
>  	sz = BITS_TO_LONGS(tbl->it_size) * sizeof(unsigned long);
>  
> 
> 
> 
> -	page = alloc_pages_node(nid, GFP_KERNEL, get_order(sz));
> -	if (!page)
> +	tbl->it_map = vzalloc_node(sz, nid);
> +	if (!tbl->it_map)
>  		panic("iommu_init_table: Can't allocate %ld bytes\n", sz);
> -	tbl->it_map = page_address(page);
> -	memset(tbl->it_map, 0, sz);
>  
> 
> 
> 
>  	iommu_table_reserve_pages(tbl, res_start, res_end);
>  
> 
> 
> 
> @@ -774,8 +771,6 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid,
>  
> 
> 
> 
>  static void iommu_table_free(struct kref *kref)
>  {
> -	unsigned long bitmap_sz;
> -	unsigned int order;
>  	struct iommu_table *tbl;
>  
> 
> 
> 
>  	tbl = container_of(kref, struct iommu_table, it_kref);
> @@ -796,12 +791,8 @@ static void iommu_table_free(struct kref *kref)
>  	if (!bitmap_empty(tbl->it_map, tbl->it_size))
>  		pr_warn("%s: Unexpected TCEs\n", __func__);
>  
> 
> 
> 
> -	/* calculate bitmap size in bytes */
> -	bitmap_sz = BITS_TO_LONGS(tbl->it_size) * sizeof(unsigned long);
> -
>  	/* free bitmap */
> -	order = get_order(bitmap_sz);
> -	free_pages((unsigned long) tbl->it_map, order);
> +	vfree(tbl->it_map);
>  
> 
> 
> 
>  	/* free table */
>  	kfree(tbl);


