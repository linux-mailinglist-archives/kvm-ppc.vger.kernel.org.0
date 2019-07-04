Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67BC45FB3A
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Jul 2019 17:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbfGDPwv (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 4 Jul 2019 11:52:51 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40803 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbfGDPwu (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 4 Jul 2019 11:52:50 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 45fjDK1zccz9sPD; Fri,  5 Jul 2019 01:52:48 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: fe7946ce0808eb0e43711f5db7d2d1599b362d02
In-Reply-To: <20190623104152.13173-1-npiggin@gmail.com>
To:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     kvm-ppc@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 1/2] powerpc/64s: Rename PPC_INVALIDATE_ERAT to PPC_ARCH_300_INVALIDATE_ERAT
Message-Id: <45fjDK1zccz9sPD@ozlabs.org>
Date:   Fri,  5 Jul 2019 01:52:48 +1000 (AEST)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sun, 2019-06-23 at 10:41:51 UTC, Nicholas Piggin wrote:
> This makes it clear to the caller that it can only be used on POWER9
> and later CPUs.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Series applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/fe7946ce0808eb0e43711f5db7d2d1599b362d02

cheers
