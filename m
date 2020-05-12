Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C0D1CF6DB
	for <lists+kvm-ppc@lfdr.de>; Tue, 12 May 2020 16:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730329AbgELORc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 12 May 2020 10:17:32 -0400
Received: from foss.arm.com ([217.140.110.172]:55932 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729336AbgELORb (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 12 May 2020 10:17:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30DF230E;
        Tue, 12 May 2020 07:17:31 -0700 (PDT)
Received: from gaia (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 032BB3F71E;
        Tue, 12 May 2020 07:17:29 -0700 (PDT)
Date:   Tue, 12 May 2020 15:17:23 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Qian Cai <cai@lca.pw>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, paulus@ozlabs.org,
        benh@kernel.crashing.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/kvm: silence kmemleak false positives
Message-ID: <20200512141723.GB14943@gaia>
References: <87y2pybu38.fsf@mpe.ellerman.id.au>
 <44807D44-98D9-431C-9266-08014C4B47F6@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44807D44-98D9-431C-9266-08014C4B47F6@lca.pw>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, May 11, 2020 at 07:43:30AM -0400, Qian Cai wrote:
> On May 11, 2020, at 7:15 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> > There is kmemleak_alloc_phys(), which according to the docs can be used
> > for tracking a phys address.
> > 
> > Did you try that?
> 
> Catalin, feel free to give your thoughts here.
> 
> My understanding is that it seems the doc is a bit misleading.
> kmemleak_alloc_phys() is to allocate kmemleak objects for a physical
> address range, so  kmemleak could scan those memory pointers within
> for possible referencing other memory. It was only used in memblock so
> far, but those new memory allocations here contain no reference to
> other memory.
> 
> In this case, we have already had kmemleak objects for those memory
> allocation. It is just that other pointers reference those memory by
> their physical address which is a known kmemleak limitation won’t be
> able to track the the connection. Thus, we always use
> kmemleak_ignore() to not reporting those as leaks and don’t scan those
> because they do not contain other memory reference.

Indeed. I replied directly to Michael along the same lines.

-- 
Catalin
