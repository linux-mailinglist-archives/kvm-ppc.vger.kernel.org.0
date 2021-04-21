Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBB1366C0B
	for <lists+kvm-ppc@lfdr.de>; Wed, 21 Apr 2021 15:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241031AbhDUNKb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 21 Apr 2021 09:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242208AbhDUNJx (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 21 Apr 2021 09:09:53 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D204FC06138A
        for <kvm-ppc@vger.kernel.org>; Wed, 21 Apr 2021 06:09:20 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4FQLVQ0XFqz9vFV; Wed, 21 Apr 2021 23:09:17 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, aneesh.kumar@linux.ibm.com
In-Reply-To: <20210419120139.1455937-1-mpe@ellerman.id.au>
References: <20210419120139.1455937-1-mpe@ellerman.id.au>
Subject: Re: [PATCH] powerpc/kvm: Fix PR KVM with KUAP/MEM_KEYS enabled
Message-Id: <161901050110.1961279.2234377326774194068.b4-ty@ellerman.id.au>
Date:   Wed, 21 Apr 2021 23:08:21 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, 19 Apr 2021 22:01:39 +1000, Michael Ellerman wrote:
> The changes to add KUAP support with the hash MMU broke booting of KVM
> PR guests. The symptom is no visible progress of the guest, or possibly
> just "SLOF" being printed to the qemu console.
> 
> Host code is still executing, but breaking into xmon might show a stack
> trace such as:
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/kvm: Fix PR KVM with KUAP/MEM_KEYS enabled
      https://git.kernel.org/powerpc/c/e4e8bc1df691ba5ba749d1e2b67acf9827e51a35

cheers
