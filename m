Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13ADADA5F
	for <lists+kvm-ppc@lfdr.de>; Mon, 29 Apr 2019 04:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfD2CGB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 28 Apr 2019 22:06:01 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:46401 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbfD2CGB (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 28 Apr 2019 22:06:01 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 44sp0j4Vkwz9s7T; Mon, 29 Apr 2019 12:05:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1556503557; bh=C9jMjFQh8bIIcTLpSucBn3+IOPxRQfPJx62R3f27fHA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZDh+JJdWNbUnjZwYJ2OgXrlC5Te6OdRn22WeQuX4mEFi/3J71pfQo+39F6D6VmfIs
         gN6aTHh8fhD28hDxoQTNfGh80vVwOayHLTgGy/WObYcwr29+LgPtSFjpNYGvpucq7e
         RFvR2OWhFp0B7fWmnkVIVl5FSX1jogLJM1ivdGOqA7fkxhMHaDiTR0CdT1LUZLyBXU
         kNwsUKwXM2eBaXfB8xSfPnOIqb8nOoKndLFvhgA8sb3l7oGWYMgduupXvs/dphOqD1
         8Md0UWqf3a3EcS154gfVMUDHZtwTRPKEseYrZA6+ZANLVUVipPwrDyKTM5PLPIDLER
         jBXEXZZQAZv0g==
Date:   Mon, 29 Apr 2019 12:05:55 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Steven Price <steven.price@arm.com>
Cc:     linux-mm@kvack.org, Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        James Morse <james.morse@arm.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Rutland <Mark.Rutland@arm.com>,
        "Liang, Kan" <kan.liang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v8 05/20] KVM: PPC: Book3S HV: Remove pmd_is_leaf()
Message-ID: <20190429020555.GB11154@blackberry>
References: <20190403141627.11664-1-steven.price@arm.com>
 <20190403141627.11664-6-steven.price@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190403141627.11664-6-steven.price@arm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Apr 03, 2019 at 03:16:12PM +0100, Steven Price wrote:
> Since pmd_large() is now always available, pmd_is_leaf() is redundant.
> Replace all uses with calls to pmd_large().

NAK.  I don't want to do this, because pmd_is_leaf() is purely about
the guest page tables (the "partition-scoped" radix tree which
specifies the guest physical to host physical translation), not about
anything to do with the Linux process page tables.  The guest page
tables have the same format as the Linux process page tables, but they
are managed separately.

If it makes things clearer, I could rename it to "guest_pmd_is_leaf()"
or something similar.

Paul.
