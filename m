Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9482DA624
	for <lists+kvm-ppc@lfdr.de>; Tue, 15 Dec 2020 03:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgLOCQn (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 14 Dec 2020 21:16:43 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:60071 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgLOCQc (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 14 Dec 2020 21:16:32 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4Cw20x6HjXz9sTL; Tue, 15 Dec 2020 13:15:45 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1607998545; bh=2lgDKiBTAfEfH0fC4r8Kmj22YXnO34qEjBvuwUv+ofs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yv2FoYZu9pG2zmCqdlHxwqktpHm+z40MP9k1xeOAN5+0xWYWVUcJKNyLecEy+szDx
         JXNZ5tTdhViXl1k4Pp3fB+IWwucG9Y7aQKynf0cEOO96oeb/2ogiSKb7yvnh2Hn3XM
         p9fgLVIALhZeClek9Onw/lj+RsZtXhX+3d8BHaulrerUcR4/lg03xAskroKhy44T26
         c+Y5prCjy51cCjnyKb3SVO/0xPsSwX5YLdlkXnLCuXqE5mJitIyFzOGn2L5MVaWq+A
         G20TC3lVWMipBTmyj6S8rNgKQ2yQsRwY4k75jPRCjddVjvB/kzA/oLUcd7GQNZpo50
         4ikACvhnC4G6g==
Date:   Tue, 15 Dec 2020 13:14:15 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     xiakaixu1987@gmail.com
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] KVM: PPC: fix comparison to bool warning
Message-ID: <20201215021415.GA2441086@thinks.paulus.ozlabs.org>
References: <1604764178-8087-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604764178-8087-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, Nov 07, 2020 at 11:49:38PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Fix the following coccicheck warning:
> 
> ./arch/powerpc/kvm/booke.c:503:6-16: WARNING: Comparison to bool
> ./arch/powerpc/kvm/booke.c:505:6-17: WARNING: Comparison to bool
> ./arch/powerpc/kvm/booke.c:507:6-16: WARNING: Comparison to bool
> 
> Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Acked-by: Paul Mackerras <paulus@ozlabs.org>
