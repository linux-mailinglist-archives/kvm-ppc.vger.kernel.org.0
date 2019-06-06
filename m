Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF90373CB
	for <lists+kvm-ppc@lfdr.de>; Thu,  6 Jun 2019 14:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfFFMIW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 6 Jun 2019 08:08:22 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:37456 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbfFFMIW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 6 Jun 2019 08:08:22 -0400
Received: by mail-wm1-f50.google.com with SMTP id 22so2165962wmg.2
        for <kvm-ppc@vger.kernel.org>; Thu, 06 Jun 2019 05:08:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I8RvB6jddbZPnktx+ihdHDDrH0fjfgh05ZRWWC2JtyI=;
        b=ZIMo0E31QNRAU/1gp/yaGK6aqs/JNrkmuEjU4eRZUq/V1+d2ifBoWu8mxqE9xjhMPH
         MM70PtWrGgET0mlnjkC+eUk/zsBf6C9REBHY9VDtTdj8pXpsQq9s/7+koAAWyfj7FRlU
         bh1DEGR3yjwGio4A3Q21tZG/9dY3zEe73FmHakoHVD03HAH42q0WR9DC8VfTbSO2vWaG
         PQZQz6mWc5gySuUbXSipg0ipdql0eMmZVpUkiSYhaW0fQ0g5rRHpmox53L+/u7ImnsnD
         NrYkJtozxB5EA3kKDVsE8nAGWUTfgVQJjU23blDjT8jenXR635CUxQi3D5lSal5lwV7L
         JSXg==
X-Gm-Message-State: APjAAAWqnzTkOkG8+6F0KigGGOzYIwOMJ8/j4Xztj/53ulpnSjxqjtd4
        9RzkzZyL5Gg7ySQDySgbPumMzQ==
X-Google-Smtp-Source: APXvYqxeQslgkTH+Cchm3M4OmTfKHWFX7M1+Js2xnKmzCoU9G4+u/5MrDHy24BlUkEGTd1oBe9Z3Bg==
X-Received: by 2002:a1c:2082:: with SMTP id g124mr25401930wmg.71.1559822901045;
        Thu, 06 Jun 2019 05:08:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id t13sm3126953wra.81.2019.06.06.05.08.20
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 05:08:20 -0700 (PDT)
Subject: Re: [kvm-unit-tests PULL 0/2] Ppc next patches
To:     Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Thomas Huth <thuth@redhat.com>
References: <20190517130305.32123-1-lvivier@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <587f9377-dda6-48c1-b520-4c2350b6a581@redhat.com>
Date:   Thu, 6 Jun 2019 14:08:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190517130305.32123-1-lvivier@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 17/05/19 15:03, Laurent Vivier wrote:
>   https://github.com/vivier/kvm-unit-tests.git tags/ppc-next-pull-request

Pulled, thanks.

Paolo
