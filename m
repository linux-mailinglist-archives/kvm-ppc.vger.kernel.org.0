Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73C433AC3C
	for <lists+kvm-ppc@lfdr.de>; Mon, 15 Mar 2021 08:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhCOH2n (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 15 Mar 2021 03:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbhCOH2e (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 15 Mar 2021 03:28:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4714C061574;
        Mon, 15 Mar 2021 00:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/4x/X3GS6thVGUK6cOVI8rH4h4+Oo61yBODFUT5MA0w=; b=vZi3bhH4d2YcxZIWoFyxnCOCzo
        hhpidY/A6Mbh0EWNvr0oyxoaxtFxeFowICoVqbo6OK+Fgs1EsPYDuqwvGPFnGYsbCBkIZSWYxCOcW
        53tvfYpwfVOOebLDQB//3YJkAXiY+BeQNlExtECW8bSXB9ZlaA8bahIuUUktyvMN0zXD25fma/ut9
        7Sa4bDI5j6qs0U6/ExHfBLXqx1JscAvFwgh3w63HrUrCUghFXuQgBKnC0iKP70Tx8EHYCGKSSEYj9
        KdWllX4zU5Vfypl+9TtxQCzfCvkQmhBD7U8ONPnT40VeCCb9W6OKibM/MKO7skATmiDfTlcrIEfFz
        B/grPu7A==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lLhdt-00HMIO-KN; Mon, 15 Mar 2021 07:27:58 +0000
Date:   Mon, 15 Mar 2021 07:27:57 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, nouveau@lists.freedesktop.org,
        bskeggs@redhat.com, akpm@linux-foundation.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        jhubbard@nvidia.com, rcampbell@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, hch@infradead.org, daniel@ffwll.ch,
        willy@infradead.org
Subject: Re: [PATCH v6 1/8] mm: Remove special swap entry functions
Message-ID: <20210315072757.GA4136862@infradead.org>
References: <20210312083851.15981-1-apopple@nvidia.com>
 <20210312083851.15981-2-apopple@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312083851.15981-2-apopple@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Mar 12, 2021 at 07:38:44PM +1100, Alistair Popple wrote:
> Remove the migration and device private entry_to_page() and
> entry_to_pfn() inline functions and instead open code them directly.
> This results in shorter code which is easier to understand.

I think this commit log should mention pfn_swap_entry_to_page() now.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
