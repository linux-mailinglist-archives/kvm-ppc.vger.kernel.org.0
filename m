Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42942EBA7D
	for <lists+kvm-ppc@lfdr.de>; Fri,  1 Nov 2019 00:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbfJaXgz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 31 Oct 2019 19:36:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59314 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728345AbfJaXgz (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 31 Oct 2019 19:36:55 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 12F5385539
        for <kvm-ppc@vger.kernel.org>; Thu, 31 Oct 2019 23:36:55 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id z9so4463797wrq.11
        for <kvm-ppc@vger.kernel.org>; Thu, 31 Oct 2019 16:36:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4LJgE7uoxIgv6lOFWTa4lMXDWH86arAwN/3SBbtX42c=;
        b=LMwdY0eINSqGHvYf6TSCbbwPLZBuQx5EexaQQxlDhRhfbhem6FFMCKYmPBCFr4kR9X
         /UgW9PxmEppMb2sVlQ6hkWSfTv7bDzjD/QphJnlg2mMF4USe2TjHFWj/pdU25IbUuw6W
         1PR0qNG8LHBao68Mt853qOrzS5co79h5asKCJILZRewNzYhf8KMdVrAxMY82O5ofrHca
         LgzfiruBdZn362rvsSaHLfm9O3qGADadmIltNutaun8xZ2UnJKlvb10RNjfPCQmkkqhP
         lKYe2+kEfXwwX5yEvM9VwprdKhbRHvVtVSX9LiJV+llVRX9p/TAV/T0mqd17kj+2DqOd
         XziQ==
X-Gm-Message-State: APjAAAW3WXc+cQ4oqMpjz3ICXIsOOh2LBXQFfXS3quTZumUC8vXOcdgA
        BBNGhufqUXQBWnPnjV/kcfjS882ZbYcBaBSxK4KvBBP24dyvGddHFW/08HxeeUSpTkBJd9iAHp7
        87Y1CqsAQ148g4JuvvA==
X-Received: by 2002:a1c:1d41:: with SMTP id d62mr7465985wmd.32.1572565013602;
        Thu, 31 Oct 2019 16:36:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxycS8wEB4d15ZosyhgQfZLFlZUbJ9aGHOZxYeJp6qJNPUEq3M8FNWBrhbLOmRzr7qE7Vkx8A==
X-Received: by 2002:a1c:1d41:: with SMTP id d62mr7465969wmd.32.1572565013331;
        Thu, 31 Oct 2019 16:36:53 -0700 (PDT)
Received: from [192.168.20.72] (94.222.26.109.rev.sfr.net. [109.26.222.94])
        by smtp.gmail.com with ESMTPSA id q14sm7476510wre.27.2019.10.31.16.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2019 16:36:52 -0700 (PDT)
Subject: Re: [GIT PULL] Please pull my kvm-ppc-next-5.5-1 tag
To:     Paul Mackerras <paulus@ozlabs.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
References: <20191031111349.GA8045@blackberry>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f41d26fb-de5e-83d1-4ec6-11c66b93c076@redhat.com>
Date:   Fri, 1 Nov 2019 00:36:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191031111349.GA8045@blackberry>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 31/10/19 12:13, Paul Mackerras wrote:
> Paolo or Radim,
> 
> Please do a pull from my kvm-ppc-next-5.5-1 tag to get a PPC KVM
> update for v5.5.
> 
> Thanks,
> Paul.
> 
> The following changes since commit 12ade69c1eb9958b13374edf5ef742ea20ccffde:
> 
>   KVM: PPC: Book3S HV: XIVE: Ensure VP isn't already in use (2019-10-15 16:09:11 +1100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc tags/kvm-ppc-next-5.5-1

Pushed to kvm/queue for now.  It may take a couple days after I get
back, before I test all the pending x86 patches and push out to kvm/next.

Paolo
