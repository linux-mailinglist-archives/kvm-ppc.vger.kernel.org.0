Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38E92B775E
	for <lists+kvm-ppc@lfdr.de>; Thu, 19 Sep 2019 12:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389325AbfISK0C (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 19 Sep 2019 06:26:02 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:52283 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389206AbfISK0C (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 19 Sep 2019 06:26:02 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 46YtKg2dGGz9s4Y; Thu, 19 Sep 2019 20:25:57 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 0cb0837f9db1a6ed5b764ef61dd5f1a314b8231a
In-Reply-To: <20190911115746.12433-1-mpe@ellerman.id.au>
To:     Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     cai@lca.pw, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 1/4] powerpc/kvm: Move kvm_tmp into .text, shrink to 64K
Message-Id: <46YtKg2dGGz9s4Y@ozlabs.org>
Date:   Thu, 19 Sep 2019 20:25:57 +1000 (AEST)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 2019-09-11 at 11:57:43 UTC, Michael Ellerman wrote:
> In some configurations of KVM, guests binary patch themselves to
> avoid/reduce trapping into the hypervisor. For some instructions this
> requires replacing one instruction with a sequence of instructions.
> 
> For those cases we need to write the sequence of instructions
> somewhere and then patch the location of the original instruction to
> branch to the sequence. That requires that the location of the
> sequence be within 32MB of the original instruction.
> 
> The current solution for this is that we create a 1MB array in BSS,
> write sequences into there, and then free the remainder of the array.
> 
> This has a few problems:
>  - it confuses kmemleak.
>  - it confuses lockdep.
>  - it requires mapping kvm_tmp executable, which can cause adjacent
>    areas to also be mapped executable if we're using 16M pages for the
>    linear mapping.
>  - the 32MB limit can be exceeded if the kernel is big enough,
>    especially with STRICT_KERNEL_RWX enabled, which then prevents the
>    patching from working at all.
> 
> We can fix all those problems by making kvm_tmp just a region of
> regular .text. However currently it's 1MB in size, and we don't want
> to waste 1MB of text. In practice however I only see ~30KB of kvm_tmp
> being used even for an allyes_config. So shrink kvm_tmp to 64K, which
> ought to be enough for everyone, and move it into .text.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Series applied to powerpc next.

https://git.kernel.org/powerpc/c/0cb0837f9db1a6ed5b764ef61dd5f1a314b8231a

cheers
