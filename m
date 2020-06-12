Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4D91F7F2F
	for <lists+kvm-ppc@lfdr.de>; Sat, 13 Jun 2020 00:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgFLWuJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 12 Jun 2020 18:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgFLWuC (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 12 Jun 2020 18:50:02 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5608EC03E96F
        for <kvm-ppc@vger.kernel.org>; Fri, 12 Jun 2020 15:50:02 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 49kGBv0g0xz9sS8; Sat, 13 Jun 2020 08:49:58 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        kvm-ppc@vger.kernel.org
In-Reply-To: <20200611030559.75257-1-aik@ozlabs.ru>
References: <20200611030559.75257-1-aik@ozlabs.ru>
Subject: Re: [PATCH kernel] KVM: PPC: Fix nested guest RC bits update
Message-Id: <159200220505.2257208.15959649065101000471.b4-ty@ellerman.id.au>
Date:   Sat, 13 Jun 2020 08:49:58 +1000 (AEST)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, 11 Jun 2020 13:05:59 +1000, Alexey Kardashevskiy wrote:
> Before commit 6cdf30375f82 ("powerpc/kvm/book3s: Use kvm helpers
> to walk shadow or secondary table") we called __find_linux_pte() with
> a page table pointer from a kvm_nested_guest struct but
> now we rely on kvmhv_find_nested() which takes an L1 LPID and returns
> a kvm_nested_guest pointer, however we pass a L0 LPID there and
> the L2 guest hangs.
> 
> [...]

Applied to powerpc/fixes.

[1/1] KVM: PPC: Fix nested guest RC bits update
      https://git.kernel.org/powerpc/c/e881bfaf5a5f409390973e076333281465f2b0d9

cheers
