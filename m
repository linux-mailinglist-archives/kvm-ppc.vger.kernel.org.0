Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38C333AC45
	for <lists+kvm-ppc@lfdr.de>; Mon, 15 Mar 2021 08:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhCOHaS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 15 Mar 2021 03:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbhCOH3w (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 15 Mar 2021 03:29:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5817C06175F;
        Mon, 15 Mar 2021 00:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sAHht8ckTKMMHMl/tMIDmrJkSFI4s7y4ycAyn33KZeY=; b=TQR3921G8E2zC7YtRH4EsTOEWS
        8TbSrWIjqXG251q+SEQnIBor5JIW4K0UiYUTzyQcQRFeU9KeKN/1X9iygL1I/7MwxlczN09sEcHqt
        MZbjjlR/QzvqdTFS7QM6BSYJqtnqj7sPNMyvzjLGcNee2kXMXyuVmM/wQuksuqcC/BElTtzX6DHbT
        Jaw2bgjGEPwnKPIOtpa1sGEETbkD5w+FJZJC9LKIPHVMOCi7N+i2uOKF0iFq8COJhTZV1OnlKk1DT
        PVmNwonRdyPf9yXaVHlFrTWITod4RYjJV7DdfOz4fbBGHnZupO8G06mdUymQW+G6yGQ17WOtHbYrY
        VJYBi44g==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lLheq-00HMMy-8c; Mon, 15 Mar 2021 07:29:05 +0000
Date:   Mon, 15 Mar 2021 07:28:56 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, nouveau@lists.freedesktop.org,
        bskeggs@redhat.com, akpm@linux-foundation.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        jhubbard@nvidia.com, rcampbell@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, hch@infradead.org, daniel@ffwll.ch,
        willy@infradead.org
Subject: Re: [PATCH v6 3/8] mm/rmap: Split try_to_munlock from try_to_unmap
Message-ID: <20210315072856.GB4136862@infradead.org>
References: <20210312083851.15981-1-apopple@nvidia.com>
 <20210312083851.15981-4-apopple@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312083851.15981-4-apopple@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Mar 12, 2021 at 07:38:46PM +1100, Alistair Popple wrote:
> The behaviour of try_to_unmap_one() is difficult to follow because it
> performs different operations based on a fairly large set of flags used
> in different combinations.
> 
> TTU_MUNLOCK is one such flag. However it is exclusively used by
> try_to_munlock() which specifies no other flags. Therefore rather than
> overload try_to_unmap_one() with unrelated behaviour split this out into
> it's own function and remove the flag.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
> 
> ---
> 
> Christoph - I didn't add your Reviewed-by from v3 because removal of the
> extra VM_LOCKED check in v4 changed things slightly. Let me know if
> you're still ok for me to add it. Thanks.

Still looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
