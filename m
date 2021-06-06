Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3327339CEB1
	for <lists+kvm-ppc@lfdr.de>; Sun,  6 Jun 2021 13:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbhFFLh7 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 6 Jun 2021 07:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhFFLh7 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 6 Jun 2021 07:37:59 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E167BC061766
        for <kvm-ppc@vger.kernel.org>; Sun,  6 Jun 2021 04:36:09 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4FyZFd4tdgz9sWD; Sun,  6 Jun 2021 21:36:05 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Fabiano Rosas <farosas@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20210526125851.3436735-1-npiggin@gmail.com>
References: <20210526125851.3436735-1-npiggin@gmail.com>
Subject: Re: [PATCH v2] KVM: PPC: Book3S HV: Save host FSCR in the P7/8 path
Message-Id: <162297929349.2342154.8811673378838617538.b4-ty@ellerman.id.au>
Date:   Sun, 06 Jun 2021 21:34:53 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 26 May 2021 22:58:51 +1000, Nicholas Piggin wrote:
> Similar to commit 25edcc50d76c ("KVM: PPC: Book3S HV: Save and restore
> FSCR in the P9 path"), ensure the P7/8 path saves and restores the host
> FSCR. The logic explained in that patch actually applies there to the
> old path well: a context switch can be made before kvmppc_vcpu_run_hv
> restores the host FSCR and returns.
> 
> Now both the p9 and the p7/8 paths now save and restore their FSCR, it
> no longer needs to be restored at the end of kvmppc_vcpu_run_hv

Applied to powerpc/fixes.

[1/1] KVM: PPC: Book3S HV: Save host FSCR in the P7/8 path
      https://git.kernel.org/powerpc/c/1438709e6328925ef496dafd467dbd0353137434

cheers
