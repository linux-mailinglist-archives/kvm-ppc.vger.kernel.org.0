Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAB6435676
	for <lists+kvm-ppc@lfdr.de>; Thu, 21 Oct 2021 01:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhJTX02 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 20 Oct 2021 19:26:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229998AbhJTX0Z (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 20 Oct 2021 19:26:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B2CD610A1;
        Wed, 20 Oct 2021 23:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634772250;
        bh=GoOxfVhzMaSH83/PPC4fKRkQJxI67w6NPcUG959R24Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kVF6fvmtL4Mu1Xj7uTGncdFr/ePyJYT/b6WZhUm5wUy+PGfRbO0ToTHqhEsLNpBFy
         28epgObVph/WB2G922TqXd++kxaJcPC8S9IRZtszlzlmkF4dMVtoDJuPaXz5iY63aL
         U2gVd6o9o4Cv2I/Z7VDw6KG8VVar5IaETUmz5ELQXbxMvR39grhgyPbWhSCCFtjmdy
         REOtw6Rwg/pCXc0FWjAb+WZ5Kr3z/dDWCeL5C82MylddzkcsUSrlaQel4o2youov6E
         55x2lsri162oQGFcL4Fm+WhNt4d86Fq3ihrMe8saqCQtEaE5Url2wNs8sBZtoVeLwv
         KqrRs9ePNTrPA==
Date:   Wed, 20 Oct 2021 18:28:49 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Len Baker <len.baker@gmx.com>, Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kees Cook <keescook@chromium.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Replace zero-length array with flexible array
 member
Message-ID: <20211020232849.GA1315641@embeddedor>
References: <20210918142138.17709-1-len.baker@gmx.com>
 <bb4faf3a-9fe9-280b-cb4c-e4904b0b2a8f@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb4faf3a-9fe9-280b-cb4c-e4904b0b2a8f@embeddedor.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Sep 20, 2021 at 07:05:07PM -0500, Gustavo A. R. Silva wrote:
> 
> 
> On 9/18/21 09:21, Len Baker wrote:
> > There is a regular need in the kernel to provide a way to declare having
> > a dynamically sized set of trailing elements in a structure. Kernel code
> > should always use "flexible array members" [1] for these cases. The
> > older style of one-element or zero-length arrays should no longer be
> > used[2].
> > 
> > Also, make use of the struct_size() helper in kzalloc().
> > 
> > [1] https://en.wikipedia.org/wiki/Flexible_array_member
> > [2] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
> > 
> > Signed-off-by: Len Baker <len.baker@gmx.com>
> 
> Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

I'm taking this in my -next tree.

Thanks
--
Gustavo
