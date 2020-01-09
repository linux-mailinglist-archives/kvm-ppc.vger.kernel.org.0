Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3210D13615A
	for <lists+kvm-ppc@lfdr.de>; Thu,  9 Jan 2020 20:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732170AbgAITrq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 9 Jan 2020 14:47:46 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46340 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731867AbgAITrq (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 9 Jan 2020 14:47:46 -0500
Received: by mail-pg1-f194.google.com with SMTP id z124so3684460pgb.13
        for <kvm-ppc@vger.kernel.org>; Thu, 09 Jan 2020 11:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tOr15WETxbkLw/hVhIIJI77xVs+gy+a9H8+1jFpIRfc=;
        b=cG0QOwda3n2lMKGGwl2gvG+FY0g5k14CGaWhbv4nmRcoT2JX4qtut3O08AYJiZSsJ1
         cr8cRqsI97d5/bOkzP8tKl3Tt9qtR5JvXtPKrWUCiPl4DV38hUy0eNUJDkm8kHbJEuBE
         yaFZx1vNucRxrssnQpATjd86jpNCMGp+2Uyc8U06zuHuUL2AoQcrnZJ+y884oRxt8t+n
         VRC8uxlGUAtadaiER22t+8Zb5vtrFxei+x4QHt8BHfVM01jX4dRRdZl9Mv3Dje2YTVYW
         tV4Ihp6XBYA3izk3Ms3j7QY4sBnbwek7lIwiWDhHQ5xPFFbll2klVlmKSmR8wUaYCyZ9
         y5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tOr15WETxbkLw/hVhIIJI77xVs+gy+a9H8+1jFpIRfc=;
        b=fDHkPlwlIVQ4ngDPb9Uvj2cdaFtT1c2fZZQYsGJCw0WkLNiKj6rLsF5Oql7s7lDDNQ
         2Mb0ZywXsjsRhzrIrZoY+wMmaeKCcZdl8Jjc0jdWAu+ZkX3L0CRz+sgpl5v12lvzJ0vD
         FAf2IJO+G2/W6Z/2YI0bbNApXo97xmYCT7Qz0v/Ob4rphz+gFsi35GUemnay4i7p/PJD
         G34/seedMvFtKR3GvTafYfiMI2EMD4G63V6Gdgeu7VgN6tM0dUfGEm7B3uu8BCKz8H4H
         8opITpDy6z5nJO/fWTebbU+4WjcEh43Wz6wF4D0qhFSfbY+WELih/s1/DEkqXiKJEVpp
         BFZw==
X-Gm-Message-State: APjAAAWB5HnqwxZNz5wWPxgRHx1ZZ/3wVAA1MI460ktz5ExixDlxa+HC
        rJGKv24JwrDsRuGYVezhAJmwXw==
X-Google-Smtp-Source: APXvYqzh23zJ0M/6YUkb1gak5IeC/b1rxGMe/2+na8ui5AM37mG7vNvlQ/Y50JVkaXV8dlCW2yJyFQ==
X-Received: by 2002:a62:e30f:: with SMTP id g15mr235672pfh.124.1578599265739;
        Thu, 09 Jan 2020 11:47:45 -0800 (PST)
Received: from gnomeregan01.cam.corp.google.com ([2620:15c:6:14:50b7:ffca:29c4:6488])
        by smtp.googlemail.com with ESMTPSA id z130sm8572761pgz.6.2020.01.09.11.47.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 11:47:44 -0800 (PST)
Subject: Re: [PATCH 00/14] KVM: x86/mmu: Huge page fixes, cleanup, and DAX
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Zeng <jason.zeng@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
From:   Barret Rhoden <brho@google.com>
Message-ID: <e3e12d17-32e4-84ad-94da-91095d999238@google.com>
Date:   Thu, 9 Jan 2020 14:47:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200108202448.9669-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi -

On 1/8/20 3:24 PM, Sean Christopherson wrote:
> This series is a mix of bug fixes, cleanup and new support in KVM's
> handling of huge pages.  The series initially stemmed from a syzkaller
> bug report[1], which is fixed by patch 02, "mm: thp: KVM: Explicitly
> check for THP when populating secondary MMU".
> 
> While investigating options for fixing the syzkaller bug, I realized KVM
> could reuse the approach from Barret's series to enable huge pages for DAX
> mappings in KVM[2] for all types of huge mappings, i.e. walk the host page
> tables instead of querying metadata (patches 05 - 09).

Thanks, Sean.  I tested this patch series out, and it works for me. 
(Huge KVM mappings of a DAX file, etc.).

Thanks,

Barret



